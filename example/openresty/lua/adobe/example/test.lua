local http_util = require "mocka.http_util"

return function()
    -- order matters - first beforeEach then afterEach
    beforeEach(function()
        -- do something here
    end)
    afterEach(function()
        -- do something here
    end)
    test('test spy say negation', function()
        spy('adobe.module.say', "say", function(self, what)
            ngx.status = 200
            ngx.print("not " .. what)
        end)

        local res, err = http_util:request("127.0.0.1", 9191)
                    :path("/test")
                    :header("Host", "test.example.adobe")
                    :get()

        assertNil(err)
        assertEquals(res.status, 200)

        --test that the spy works
        assertEquals(res.body, "not hello")
    end)
    test('test that a spy is back to normal', function()
        local res, err = http_util:request("127.0.0.1", 9191)
                                  :path("/test")
                                  :header("Host", "test.example.adobe")
                                  :get()

        assertNil(err)
        assertEquals(res.status, 200)

        calls(spy("adobe.module.say").say, 1)
        assertEquals(res.body, "hello")
    end)
end