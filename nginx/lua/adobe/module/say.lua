local M = {}

function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function M:say(what)
    ngx.status = 200
    ngx.print(what)
end

return M