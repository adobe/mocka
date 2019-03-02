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

test('override lazy spy', function()
    spy("cjson", "decode", function()
        return "overwritten"
    end)

    local cjson = require "cjson"
    assertEquals(cjson.decode(), "overwritten")
end)

test('override preloaded module spy', function()
    spy("src.test.adobe.mocka.some_class", "testing", function()
        return "overwritten preloaded module"
    end)
    assertEquals(some_class:testing(), "overwritten preloaded module")
end)

test('just beforeEach on preload', function()
    assertEquals(some_class:testing(), "beforeEach")
end)
