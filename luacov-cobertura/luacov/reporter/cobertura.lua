local luacov_reporter = require("luacov.reporter")
local luatoxml = require("luacov.cobertura.luatoxml")

local ReporterBase = luacov_reporter.ReporterBase

-- ReporterBase provide
--  write(str) - write string to output file
--  config()   - return configuration table

local cobertura_reporter = setmetatable({}, ReporterBase) do
cobertura_reporter.__index = cobertura_reporter

function cobertura_reporter:new(conf)
	local o, err = ReporterBase.new(self, conf)
	if not o then
		return nil, err
	end

	self.mangleFile = conf.cobertura.mangleFile or function(fileName)
		return fileName
	end

	if conf.cobertura.filenameparser then
		local parsed_data = {}
		local files = {}
		for filename,stats in pairs(o._data) do
			local parsed_filename = conf.cobertura.filenameparser(filename)
			if parsed_data[parsed_filename] == nil or parsed_data[parsed_filename].max < stats.max then
				parsed_data[parsed_filename] = stats
				table.insert(files, parsed_filename)
			end
		end
		o._data = parsed_data
		o._files = files
	end

	return o
end

function cobertura_reporter:on_start()
	self.cobertura = {
		coverage = {
			["line-rate"] = 0,
			["branch-rate"] = 0,
			version = "1.9",
			timestamp = os.time() * 1000,
			sources = {},
			packages = {}
		}
	}

	self.summaries = {}
end

function cobertura_reporter:on_new_file(filename)
	local class_name = filename:gsub("^.*/", "") -- "test/package/file.lua" -> "file.lua"
	local package_name = filename:gsub(filename:gsub("^.*/", ""), ""):gsub("/$", "") -- "test/package/file.lua" -> "test/package"

	local package
	for _,p in pairs(self.cobertura.coverage.packages) do
		if p.package.name == package_name then
			package = p.package
			break
		end
	end
	-- create package if we weren't able to find it
	if not package then
		package = {
			name = package_name,
			["line-rate"] = 0,
			["branch-rate"] = 0,
			complexity = 0,
			classes = {},
		}
		table.insert(self.cobertura.coverage.packages, { package = package })
	end


	local class = {
		name = class_name,
		filename = filename,
		["line-rate"] = 0,
		["branch-rate"] = 0,
		complexity = 0,
		methods = {},
		lines = {},
	}
	table.insert(package.classes, { class = class })

	self.current_package = package
	self.current_class = class
end

function cobertura_reporter:on_empty_line(filename, lineno, line)
end

function cobertura_reporter:on_mis_line(filename, lineno, line)
	table.insert(self.current_class.lines, { line = { number = lineno, hits = 0, branch = false } })
end

function cobertura_reporter:on_hit_line(filename, lineno, line, hits)
	table.insert(self.current_class.lines, { line = { number = lineno, hits = hits, branch = false } })
end

--- Handle when a file has been completely parsed from start to end
-- @param filename
-- @param hits
-- @param miss
function cobertura_reporter:on_end_file(filename, hits, miss)
	self.current_class["line-rate"] = hits / (hits + miss)
	self.summaries[filename] = {
		hits = hits,
		miss = miss,
	}
end

--- Handle when the entire report has been completely parsed
function cobertura_reporter:on_end()
	-- calculate the line rate for each package
	for _,p in pairs(self.cobertura.coverage.packages) do
		local line_rate = 0
		local package = p.package
		for _,c in pairs(package.classes) do
			local class = c.class
			line_rate = line_rate + class["line-rate"]
		end
		package["line-rate"] = line_rate / #package.classes
	end

	-- calculate the total line rate
	local total_hits = 0
	local total_miss = 0
	for _,summary in pairs(self.summaries) do
		total_hits = total_hits + summary.hits
		total_miss = total_miss + summary.miss
	end
	self.cobertura.coverage["line-rate"] = (total_hits / (total_hits + total_miss))

	local cjson = require "cjson"
	for k,v in pairs(self.cobertura.coverage.packages) do
		for i,j in pairs(v.package.classes) do
			self.cobertura.coverage.packages[k].package.classes[i].class.filename =
				self.mangleFile(j.class.filename)
		end
	end
	local xml = luatoxml.toxml(self.cobertura)
	self:write(xml)
end

end

local reporter = {}

function reporter.report()
	return luacov_reporter.report(cobertura_reporter)
end

return reporter
