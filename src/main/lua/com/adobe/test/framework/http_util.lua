local resty_http = require "resty.http"
local cjson = require "cjson"
local HttpRequest = {}
local DEFAULT_TIMEOUT = 10000

function HttpRequest:request(host, port, ssl)
    self.req_object = {
        headers = {},
        path = '/',
        query = {},
        method = 'GET',
        ssl_verify = false
    }
    self.host = 'localhost'
    self._timeout = DEFAULT_TIMEOUT

    host = host or "localhost"
    ssl = ssl or false

    if not ssl then
        self.host = 'http://' .. host
    else
        self.host = 'https://' .. host
    end

    if port then
        self.host = self.host .. ":" .. port
    end

    return self
end

function HttpRequest:timeout(timeout)
    if timeout then
        self._timeout = timeout
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
    return self:_makeRequest()
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
    print("making request ", self.host)
    local httpc = resty_http.new()
    httpc:set_timeout(self._timeout)
    local res, err = httpc:request_uri(self.host, self.req_object)
    if res then
        print(string.format("req to host=%s method=%s path=%s responded with status=%s",
            self.host, self.req_object.method, self.req_object.path, res.status))
    end

    if err then
        print(string.format("req to host=%s method=%s path=%s responded with err=%s",
            self.host, self.req_object.method, self.req_object.path, err))
    end

    return res, err
end

return HttpRequest

