package = "mocka"
version = "1.0-1"
local function make_plat(plat)
    return { modules = {
        mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
        ["luacov.cobertura.luatoxml"] = "luacov-cobertura/luacov/cobertura/luatoxml.lua",
        ["luacov.reporter.cobertura"] = "luacov-cobertura/luacov/reporter/cobertura.lua"
    } }
end
source = {
    url = "..."
}
build = {
	type = "builtin",
	platforms = {
		unix = make_plat("unix"),
		macosx = make_plat("macosx"),
		haiku = make_plat("haiku"),
		win32 = make_plat("win32"),
		mingw32 = make_plat("mingw32")
	},
	install = {
      bin = {
        ['luacov-cobertura'] = 'luacov-cobertura/bin/luacov-cobertura'
      }
    }
}