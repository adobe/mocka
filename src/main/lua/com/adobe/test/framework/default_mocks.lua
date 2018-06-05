--
-- Created by trifan.
-- DateTime: 17/01/2018 10:34
--

--- Module offering mock defaults, used when testing various nginx features

--- Initializes the mocks used throughout the testing framework
--- @return ngxMock default mocks table
function makeNgxMock()
    local ngxMock = mock("ngx", { "log", "time", "decode_base64", "print", "say", "exit", "now", "md5" })
    ngxMock.apiGateway = mock("ngx.apiGateway", { "validateRequest" })
    ngxMock.var = {}
    ngxMock.ctx = {}
    ngxMock.HTTP_OK = 200
    ngxMock.ERR = 1
    ngxMock.WARN = 2
    ngxMock.INFO = 3
    ngxMock.DEBUG = 4
    ngxMock.NOTICE = 5
    ngxMock.req = mock("ngx.req", { "get_uri_args", "get_headers", "set_header", "start_time" })
    ngxMock.location = mock("ngx.mock", { "capture" })
    ngxMock.null = nil
    return ngxMock
end

return {
    makeNgxMock = makeNgxMock
}

--maybe make ngx.time and ngx.req.start_time get os.time