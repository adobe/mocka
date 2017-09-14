--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 07/01/17
-- Time: 03:15
-- To change this template use File | Settings | File Templates.
--
-- array of tests to run - the exact require relative to run_tests.lua
require("mocka")

mockNgx();
local run_tests = function(tests)
    for i, module in ipairs(tests) do
        print("\n\t Running " .. module .. '\n\t -----------------------------------------------------------------------\n')
        clearMocks()
        require(module)
    end
    print("\n Tests: " .. mockaStats.no .. " Pass: " .. mockaStats.noOK .. " Fail: " .. mockaStats.noNOK)
    if(mockaStats.noNOK > 0) then
        os.exit(-1)
    end
end

return run_tests

