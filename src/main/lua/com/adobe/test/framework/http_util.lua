local resty_http = require "resty.http"
local cjson = require "cjson"
local HttpRequest = {}

function HttpRequest:request(host, port, ssl)
    self.req_object = {
        host = 'localhost',
        headers = {},
        path = '/',
        query = {},
        method = 'GET',
        ssl_verify = false
    }
    self.timeout = 10000

    host = host or "localhost"
    ssl = ssl or false

    if not ssl then
        self.req_object.host = 'http://' .. host
    else
        self.req_object.host = 'https://' .. host
    end

    if port then
        self.req_object.host = self.req_object.host .. ":" .. port
    end

    return self
end

function HttpRequest:timeout(timeout)
    if timeout then
        self.timeout = timeout
    end

    return self
end

function HttpRequest:header(key, value)
    if not self.req_object.headers[key] then
        self.req_object.headers[key] = { value }
    else
        table.insert(self.req_object.headers[key], value)
    end
    return self
end

function HttpRequest:path(path)
    self.req_object.path = path
    return self
end

function HttpRequest:query(key, value)
    if not self.req_object.query[key] then
        self.req_object.query[key] = { value }
    else
        table.insert(self.req_object.query[key], value)
    end

    return self
end

function HttpRequest:get()
    self.req_object.method = "GET"
end

function HttpRequest:post(body)
    body = body or {}
    if self.req_object.headers["Content-Type"] == "application/json" then
        self.req_object.body = cjson.encode(body)
    else
        self.req_object.body = body
    end
    self.req_object.method = "POST"

    return self:_makeRequest()
end

function HttpRequest:put(body)
    body = body or {}
    if self.req_object.headers["Content-Type"] == "application/json" then
        self.req_object.body = cjson.encode(body)
    else
        self.req_object.body = body
    end
    self.req_object.method = "PUT"

    return self:_makeRequest()
end

function HttpRequest:delete()
    self.req_object.method = "DELETE"

    return self:_makeRequest()
end

function HttpRequest:options()
    self.req_object.method = "OPTIONS"

    return self:_makeRequest()
end

function HttpRequest:_makeRequest()
    local httpc = resty_http.new()
    httpc:set_timeout(self.timeout)
    local res, err = httpc:request_uri(self.req_object)
    if res then
        print(string.format("req to host=%s method=%s path=%s responded with status=%s",
            self.req_object.host, self.req_object.path, self.req_object.method, res.status))
    end

    if err then
        print(string.format("req to host=%s method=%s path=%s responded with err=%s",
            self.req_object.host, self.req_object.path, self.req_object.method, err))
    end

    return res, err
end

return HttpRequest

