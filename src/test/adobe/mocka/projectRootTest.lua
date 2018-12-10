--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 12/8/18
-- Time: 19:26
-- To change this template use File | Settings | File Templates.
--
local function execCommand(cmd)
    local pipe = io.popen(cmd)
    local result = pipe:read('*a')
    pipe:close()
    return result
end

test('it should set a project root and work', function()
    local result = execCommand("mocka ./src/test/adobe/mocka/rootTest.lua")
    assertNil(string.find(result, "SUCCESS"))
    local result = execCommand("mocka ./src/test/adobe/mocka/rootTest.lua -p ./src/test/dir/in/src")
    assertNotNil(string.find(result, "SUCCESS"))
end)

