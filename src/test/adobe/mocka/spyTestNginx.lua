local some_class = require "src.test.adobe.mocka.some_class"
beforeEach(function()
    isNgx = true
    spy("cjson", "decode", function()
        return "first"
    end)
    spy("src.test.adobe.mocka.some_class", "testing", function()
        return "beforeEach"
    end)
end)

afterEach(function()
    isNgx = false
end)

test('nginx - override lazy spy nginx', function()
    spy("cjson", "decode", function()
        return "overwritten"
    end)

    local cjson = require "cjson"
    assertEquals(cjson.decode(), "overwritten")

    reset_spy("cjson", "decode")

    local payload = '{"key":"test"}'
    local decoded = {}
    decoded["key"] = "test"

    local cjson = require "cjson"
    assertEquals(cjson.decode(payload), decoded)
end)

test('nginx - override preloaded module spy nginx', function()
    spy("src.test.adobe.mocka.some_class", "testing", function()
        return "overwritten preloaded module"
    end)
    assertEquals(some_class:testing(), "overwritten preloaded module")

    reset_spy("src.test.adobe.mocka.some_class", "testing")
    assertEquals(some_class:testing(), "real")
end)

test('nginx - just beforeEach on preload nginx', function()
    assertEquals(some_class:testing(), "beforeEach")

    reset_spy("src.test.adobe.mocka.some_class", "testing")
    assertEquals(some_class:testing(), "real")
end)
