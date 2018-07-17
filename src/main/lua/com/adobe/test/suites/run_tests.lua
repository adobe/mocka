--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 07/01/17
-- Time: 03:15
-- To change this template use File | Settings | File Templates.
--
-- array of tests to run - the exact require relative to run_tests.lua
local testSuites = '<testsuites disabled="%s" errors="0" failures="%s" name="" tests="%s" time="%s">\n'
local testSuite = '\t<testsuite name="%s" tests="%s" disabled="%s" errors="" failures="%s" id="%s" time="%s" timestamp="">\n'
local testCase = '\t\t<testcase name="%s" assertions="%s" classname="%s" status="" time="%s">\n'
local failureMessage = '\t\t\t<failure message="%s"> </failure>\n'
local skippedMessage = '\t\t\t<skipped/>\n'

local junitOut = {}
require("mocka")


mockNgx();

local xmlOutput = function()
    table.insert(junitOut, '<?xml version="1.0" encoding="UTF-8"?>\n')
    table.insert(junitOut, string.format(testSuites, tostring(mockaStats.noIgnored), tostring(mockaStats.noNOK),
        tostring(mockaStats.no), tostring(mockaStats.time)))
    for i, suiteData in ipairs(mockaStats.suites) do
        table.insert(junitOut, string.format(testSuite, suiteData.name, tostring(suiteData.no), tostring(suiteData.noIgnored),
            tostring(suiteData.noNOK), tostring(i - 1), tostring(suiteData.time)))
        for j, testData in ipairs(suiteData.tests) do
            table.insert(junitOut, string.format(testCase, testData.name, tostring(testData.assertions), testData.className, tostring(testData.time)))
            if testData.failureMessage then
                table.insert(junitOut, string.format(failureMessage, testData.failureMessage))
            elseif testData.skipped then
                table.insert(junitOut, skippedMessage)
            end
            table.insert(junitOut, "\t\t</testcase>\n")
        end
        table.insert(junitOut, "\t</testsuite>\n")
    end
    table.insert(junitOut, "</testsuites>\n")
    local file,err = io.open("test-results.xml", "wb" )
    if not err then
       for line, data in ipairs(junitOut) do
          file:write(data)
       end
       file:close()
    end
end

local run_tests = function(tests)
    resetStats()
    local startFullTime = os.clock()
    for i, module in ipairs(tests) do
        print("\n\t Running " .. module .. '\n\t -----------------------------------------------------------------------\n')
        table.insert(mockaStats.suites, {
            name = module,
            no = 0,
            noOK = 0,
            noNOK = 0,
            noIgnored = 0,
            tests = {},
            time = 0
        })
        mockNgx()
        local startTime = os.clock()
        require(module)
        local elapsed = os.clock() - startTime

        mockaStats.suites[i].time = elapsed
        print("\n Suite info name " .. mockaStats.suites[i].name .. " Tests: " .. mockaStats.suites[i].no ..
                " Pass: " .. mockaStats.suites[i].noOK .. " Fail: " .. mockaStats.suites[i].noNOK ..
                " Ignored: " .. mockaStats.suites[i].noIgnored .. " Duration: " .. tostring(mockaStats.suites[i].time))
    end
    local elapsedFullTime = os.clock() - startFullTime

    mockaStats.time = elapsedFullTime
    print("\n Tests: " .. mockaStats.no .. " Pass: " .. mockaStats.noOK .. " Fail: " .. mockaStats.noNOK ..
            " Ignored : " .. mockaStats.noIgnored .. " Duration: " .. tostring(mockaStats.time))

    xmlOutput()
    if(mockaStats.noNOK > 0) then
        os.exit(-1)
    end
end

return run_tests

