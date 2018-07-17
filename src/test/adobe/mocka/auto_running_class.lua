--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 7/16/18
-- Time: 19:37
-- To change this template use File | Settings | File Templates.
--
local M = {}

function M:new(o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function M:doSomething()
    return true
end

return M:new()
