local instance
local MessagingQueue = {}

function MessagingQueue:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.handlers = {}
    self.messages = {}
    return o
end

function MessagingQueue:on(message, callback)
    ngx.log(ngx.ERR, " registering listener for ", message)
    self.handlers[message] = callback
end

function MessagingQueue:emit(message, data, cb)
    if not self.messages[message] then
        self.messages[message] = {}
    end

    table.insert(self.messages[message], {
        data = data,
        cb = cb
    })
    ngx.log(ngx.ERR, "emiting message ", message)
end

function MessagingQueue:_resolveMessages()
    ngx.log(ngx.ERR, "checking for messages")
    for k, v in pairs(self.messages) do
        if v and self.handlers[k] then
            for i, j in ipairs(v) do
                local status, res = pcall(self.handlers[k], j.data)
                pcall(j.cb, status, res)
            end
        end
        self.messages[k] = {}
    end

end

function MessagingQueue:checkEvents()
    self:_resolveMessages()
end

local function getInstance()
    if not instance then
        ngx.log(ngx.ERR, "retrieve once new")
        instance = MessagingQueue:new()
    end
    ngx.log(ngx.ERR, "retrieve old")
    return instance
end

return {
    getInstance = getInstance
}
