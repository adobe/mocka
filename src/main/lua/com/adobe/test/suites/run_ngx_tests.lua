--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 07/01/17
-- Time: 03:15
-- To change this template use File | Settings | File Templates.
--
-- array of tests to run - the exact require relative to run_tests.lua
local Output = require "mocka.output"

local run_tests = function(tests)
    resetStats()
    local startFullTime = os.clock()
    for i, module in ipairs(tests) do
        clearSuite()
        print("\n\t Running " .. module .. '\n\t -----------------------------------------------------------------------\n')
        table.insert(mockaStats.suites, {
            name = module,
            no = 0,
            noOK = 0,
            noNOK = 0,
            noIgnored = 0,
            noErrors = 0,
            tests = {},
            time = 0
        })

        local startTime = os.clock()
        require(module)()
        local elapsed = os.clock() - startTime

        mockaStats.suites[i].time = elapsed
        print("\n Suite info name " .. mockaStats.suites[i].name .. " Tests: " .. mockaStats.suites[i].no ..
                " Pass: " .. mockaStats.suites[i].noOK .. " Fail: " .. mockaStats.suites[i].noNOK ..
                " Error: " .. mockaStats.suites[i].noErrors or tostring(0) ..
                " Ignored: " .. mockaStats.suites[i].noIgnored .. " Duration: " .. tostring(mockaStats.suites[i].time))
    end
    local elapsedFullTime = os.clock() - startFullTime

    mockaStats.time = elapsedFullTime
    print("\n Tests: " .. mockaStats.no .. " Pass: " .. mockaStats.noOK .. " Fail: " .. mockaStats.noNOK ..
            " Error: " .. mockaStats.noErrors or tostring(0) ..
            " Ignored: " .. mockaStats.noIgnored .. " Duration: " .. tostring(mockaStats.time) .. "s")

    Output:xml()
    return Output:list()
end

return run_tests

