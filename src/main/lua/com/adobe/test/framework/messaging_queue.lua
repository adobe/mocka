local instance
local MessagingQueue = {}

function MessagingQueue:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.handlers = {}
    self.messages = {}
    self.executed = true
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

local function _resolveMessages(premature, context)
    ngx.log(ngx.ERR, "checking for messages")
    context.executed = true
    for k, v in pairs(context.messages) do
        if v and context.handlers[k] then
            for i, j in ipairs(v) do
                local status, res = pcall(context.handlers[k], j.data)
                pcall(j.cb, status, res)
            end
        end
        v = nil
    end

end

function MessagingQueue:checkEvents()
    ngx.log(ngx.ERR, " check events ", self.executed)
    if self.executed then
        self.executed = false
        ngx.timer.at(2, _resolveMessages, self)
    end
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
