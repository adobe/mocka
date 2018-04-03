local instance

local Debugger = {}

function Debugger:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Debugger:_traceFunction(event, line)
    print("OK")
end

function Debugger:setHook()
    debug.sethook(self._traceFunction, "l")
end

function Debugger:removeHook()
    debug.sethook()
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