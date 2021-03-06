---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by trifan.
--- DateTime: 13/08/2018 17:06
---
local coverage_info = require "coverage_modules"
local configuration = {
    -- standard luacov configuration keys and values here
    cobertura = {
        -- this function will be called for each filename in the stats file
        -- the function may be used to manipulate the path before the file is
        -- processed by the report generator
        mangleFile = function(filename)
            -- do stuff with the filename here
            local words = filename:gmatch("([^/%.)]+)")
            local splitPath = {}
            for word in words do
                table.insert(splitPath, word)
            end

            if coverage_info.modules[splitPath[#splitPath - 1]] then
                return coverage_info.modules[splitPath[#splitPath - 1]]
            end

            return filename
        end
    }
}
return configuration