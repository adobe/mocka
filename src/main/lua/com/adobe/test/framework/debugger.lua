local cjson = require "cjson"
local lfs = require "lfs"
local messaging_queue = require "mocka.messaging_queue":getInstance()

local instance

local Debugger = {}

function Debugger:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.debugMap = {}
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

    webSocketConnection:on("get_file", function(message)
        local content = parent:readFile(message.path)
        parent.webSocketConnection:send_text(cjson.encode({
            event = 'file',
            data = {
                path = message.path,
                content = content
            }
        }))
    end)

    webSocketConnection:on("get_fs", function(message)
        local fs = parent:getFs(message.path)
        parent.webSocketConnection:send_text(cjson.encode({
            event = 'fs',
            data = fs
        }))
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
                    isDir = true,
                    path = f,
                    name = file,
                    list = self:getFs(f)
                }
            else
                table.insert(fs, {
                    type = "file",
                    isDir = false,
                    path = f,
                    name = file
                })
            end
        end
    end
    return fs
end

function Debugger:registerBreakPoint(file, line)
    ngx.log(ngx.ERR, "registering break point ", file, ":", line)
    self.debugMap[file .. ":" .. line] = true
end

function Debugger:deRegisterBreakPoint(file, line)
    self.debugMap[file .. ":" .. line] = nil
end



function Debugger:_traceFunction(event, line)
    local debugInfo = debug.getinfo(3)
    local fileName, occurences = string.gsub(debugInfo.source, "@", "")

    if self.debugMap[fileName .. ":" .. line] then
        --- send message
        self:breakPointReached(fileName, line)
    end
end

function Debugger:breakPointReached(file, line)
    local message = {
        event = "break_point_reached",
        data = {
            file = file,
            line = line,
            retrieved_variables = self:retrieveLocalVariables()
        }
    }


    ngx.log(ngx.ERR, "try to send ", cjson.encode(message))
    self.continueExecution = false
    messaging_queue:emit("send_message", message, function(status, res)
        if status then
            ngx.log(ngx.ERR, "executed ok")
        else
            ngx.log(ngx.ERR, " failed ", res)
        end
    end)

    local sleep = function()
        local ffi = require("ffi")
        ffi.cdef[[
            void Sleep(int ms);
            int poll(struct pollfd *fds, unsigned long nfds, int timeout);
            ]]

        local sleep
        if ffi.os == "Windows" then
            function sleep(s)
                ffi.C.Sleep(s*1000)
            end
        else
            function sleep(s)
                ffi.C.poll(nil, 0, s*1000)
            end
        end

        for i=1,160 do
            io.write("."); io.flush()
            sleep(2)
        end
        io.write("\n")
    end

    sleep()


--    while not self.continueExecution do
--        ngx.sleep(2)
--    end

end

function Debugger:retrieveLocalVariables()
    local i = 1
    local local_vars = {}

    while true do
        -- the exact point where I am injected
        local n, v = debug.getlocal(5, i)
        if not n then break end
        local_vars[n] = self:getVars(v)
        i = i + 1
    end

    return local_vars
end

function Debugger:getVars(entry)
    local vars = {}
    local dont = false
    if type(entry) == "table" then
        for k, v in ipairs(entry) do
            vars[k] = self:getVars(v)
            dont = true
        end
        if not dont then
            for i, j in pairs(entry) do
                vars[i] = self:getVars(j)
            end
        end
        return vars
    end

    return tostring(entry)
end

function Debugger:setWS(webSocketConnection)
    self:_registerHandlers(webSocketConnection)
    self.webSocketConnection = webSocketConnection
end

function Debugger:setHook()
    local parent = self
    debug.sethook(function(...)
        parent:_traceFunction(...)
    end, "l")
end

function Debugger:removeHook()
    debug.sethook()
    self.webSocketConnection = nil
end

local open = io.open

local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function Debugger:readFile(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
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