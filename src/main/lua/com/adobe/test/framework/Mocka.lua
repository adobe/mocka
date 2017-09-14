--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 08/01/17
-- Time: 11:30
-- To change this template use File | Settings | File Templates.
--
oldRequire = require
local mocks = {}
local beforeFn = nil;

local function _compare(t1, t2)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not _compare(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not _compare(v1,v2) then return false end
    end
    return true
end

require = function(path)
    --wanna force reload the package
    package.loaded[path] = nil
    if(mocks[path] ~= nil) then
        return mocks[path]
    else
       return oldRequire(path)
    end
end

function beforeEach(fn)
    beforeFn = fn
end

function test(description, fn, assertFail)
    for k, v in pairs(mocks) do
        for method, impl in pairs(v) do
            if impl~=nil and type(impl) == 'table' and impl.calls then
                impl.calls = 0
                impl.latestCallWith = nil
                impl.doReturn = nil
            end
        end
    end

    if(beforeFn ~= nil) then
        pcall(beforeFn)
    end

    local status, result = pcall(fn)
    if not status and not assertFail then
        print("\t\t " .. description .. " ----- FAIL ")
        print(result)
    else
        print("\t\t " .. description .. " ----- SUCCESS ")
    end
end

function clearMocks()
    mocks = {}
end

function mock(class, model)
    local newThing = {}
    for i,method in ipairs(model or {}) do
        newThing["__"..method] = {
            calls = 0,
            name = class .. "." .. method,
            latestCallWith = nil,
            doReturn = nil
        }
        newThing[method] = _makeFunction(method, newThing)
    end
    mocks[class] = newThing
    return newThing
end

function _makeFunction(name, classToMock)
    return function(self, ...)
        classToMock["__" .. name]['calls'] = classToMock["__" .. name]['calls'] + 1
        local callingArguments = table.pack(...)
        table.insert(callingArguments, self)
        classToMock["__" .. name]['latestCallWith'] = callingArguments
        if name == 'new' and classToMock["__" .. name].doReturn == nil then
            local o = callingArguments or {}
            setmetatable(o, self)
            self.__index = self
            return o
        elseif classToMock["__" .. name].doReturn ~= nil then
            return classToMock["__" .. name].doReturn(table.unpack(callingArguments))
        end
    end
end

function calls(method, times, ...)
    if(method.calls ~= times) then
        error(method.name .. " wanted " .. times .. " but invoked " .. method.calls)
    end

    local arguments = table.pack(...)

    for k, v in pairs(arguments) do
        if k ~= 'n' then
            if not _compare(method.latestCallWith[k], v) then
                error(method.name .. " wanted with some arguments but invoked with other ")
            end
        end
    end
end

function mockNgx(conf)
    if not conf then
        ngx = {
            apiGateway = nil,
            config = {
                routes = {'smart'}
            },
            log = function() end,
        }
    else
        ngx =  conf
    end
end


function assertEquals(t1, t2)
    if not _compare(t1, t2) then
        error("assertEquals failed")
    end
end

function assertNil(t1)
    if t1 ~= nil then
        error("assertNil failed")
    end
end

function assertNotNil(t1)
    if t1 == nil then
        error("assertNotNil failed")
    end
end

function assertNotEquals(t1, t2)
    if _compare(t1, t2) then
        error("assertNotEquals failed")
    end
end