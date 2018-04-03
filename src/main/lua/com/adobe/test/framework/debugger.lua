local cjson = require "cjson"
local lfs = require "lfs"

local instance

local Debugger = {}

function Debugger:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.debugMap = {}
    self.continueExecution = false
    return o
end

function Debugger:_registerHandlers(webSocketConnection)
    local parent = self

    webSocketConnection:on("break_point", function(message)
        if message.enable then
            parent:registerBreakPoint(message.file, message.line)
        else
            parent:deRegisterBreakPoint(message.file, message.line)
        end
    end)

    webSocketConnection:on("get_fs", function(message)
        local fs = parent:getFs(message.path)
        parent.webSocketConnection:send_text(cjson.encode(fs))
    end)

    webSocketConnection:on("continue", function()
        parent.continueExecution = true
    end)

    webSocketConnection:on("introspect", function(message)
        ngx.log(ngx.ERR, "message", cjson.encode(message))
    end)
end

function Debugger:getFs(path)
    local fs = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path ..'/'..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" then
                fs[f] = {
                    type = "dir",
                    path = f,
                    list = self:getFs(f)
                }
            else
                table.insert(fs, {
                    type = "file",
                    path = f,
                    name = file
                })
            end
        end
    end
    return fs
end

function Debugger:registerBreakPoint(file, line)
    self.debugMap[file .. ":" .. line] = true
end

function Debugger:deRegisterBreakPoint(file, line)
    self.debugMap[file .. ":" .. line] = nil
end

function Debugger:_traceFunction(event, line)
    local debugInfo = debug.getinfo(2)
    local fileName, occurences = string.gsub(debugInfo.source, "@", "")
    if self.debugMap[fileName .. ":" .. line] then
        --- send message
        self:breakPointReached(fileName, line)
        while not self.continueExecution do
            ngx.sleep(1)
        end

        -- next time when a breakpoint comes to play will stop
        self.continueExecution = false
    end
end

function Debugger:breakPointReached(file, line)
    local message = {
        type = "break_point_reached",
        file = file,
        line = line
    }

    local bytes, err = self.webSocketConnection:send_text(cjson.encode(message))
    if not bytes then
        ngx.log(ngx.ERR, "Failed to send data over websocket")
        -- I should continue execution if client is gone - means that debugger session ended
        self.continueExecution = true
    end
end

function Debugger:setHook(webSocketConnection)
    local parent = self
    self:_registerHandlers(webSocketConnection)
    self.webSocketConnection = webSocketConnection
    debug.sethook(function(...)
        parent:_traceFunction(...)
    end , "l")
end

function Debugger:removeHook()
    debug.sethook()
    self.webSocketConnection = nil
end

local function getInstance()
    if not instance then
        instance = Debugger:new()
    end
    return instance
end

return {
    getInstance = getInstance
}