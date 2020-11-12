--
-- Created by IntelliJ IDEA.
-- User: trifan
-- Date: 07/01/17
-- Time: 03:15
-- To change this template use File | Settings | File Templates.
--
local defaultTests = {
    "adobe.example.test"
}

return {
    ["run"] = function(self, tests)
        if tests == nil or next(tests) == nil then
            tests = defaultTests
        end
        return require("mocka.ngx_suite")(tests)
    end
}


