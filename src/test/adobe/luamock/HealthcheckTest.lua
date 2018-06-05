---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by vdatcu.
--- DateTime: 11/05/2018 14:10
---

beforeEach(function()
    spy("cjson", "encode", function(data)
        return "before_each_" .. data
    end)
end)

test("Mocka is loaded and works", function()
    local dummyValue = {}
    local nilValue
    assertEquals(1, 1)
    assertNotNil(dummyValue)
    assertNil(nilValue)
    assertNotEquals(1, 2)
    assertEquals({},{})
    assertEquals({1,2,3}, {1,2,3})
    assertNotEquals({1,2,3}, {2,3,1})
    assertEquals({ foo = "bar" , bar = "foo" }, { foo = "bar", bar = "foo" })
    assertEquals({ foo = { a = "b"}, bar = "foo" }, { foo = { a = "b"}, bar = "foo" })
end)

test("spy works lazy mode", function()
    spy("cjson", "decode", function(data)
        return data
    end)

    spy("cjson", "encode", function(data)
        return data
    end)

    local cjson = require "cjson"
    local encodeResult = cjson.encode("encode")
    local decodeResult = cjson.decode("decode")
    assertEquals(encodeResult, "encode")
    assertEquals(decodeResult, "decode")
end)

test("spy works post mortem mode", function()
    local cjson = require "cjson"

    spy("cjson", "decode", function(data)
        return data
    end)

    spy("cjson", "encode", function(data)
        return data
    end)
    local encodeResult = cjson.encode("encode")
    local decodeResult = cjson.decode("decode")
    assertEquals(encodeResult, "encode")
    assertEquals(decodeResult, "decode")
end)

test('spies are reset for each test', function()
    local cjson = require "cjson"

    local status, err = pcall(cjson.decode, "wrong")
    assertEquals(status, false)
end)

test('spies are preserved if beforEach exists', function()
    local cjson = require "cjson"

    local result = cjson.encode("encode")
    assertEquals(result, "before_each_encode")
end)


test('xtest is always ignored', function()
    local global

    test('first run a test', function()
        global = "notChanged"
    end)

    xtest('this test sets a global variable', function()
        global = "set"
    end)

    assertEquals(global, "notChanged")
end)