package = "mocka"
version = "1.0.0-1"
local function make_plat(plat)
    return { modules = {
        mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
        ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
        ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
        ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua",
        ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
        ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
        ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
        ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
        ["luacov.cobertura.luatoxml"] = "luacov-cobertura/luacov/cobertura/luatoxml.lua",
        ["luacov.reporter.cobertura"] = "luacov-cobertura/luacov/reporter/cobertura.lua"
    } }
end
source = {
    url = "..."
}
description = {
    summary = "The one lua testing framework that mocks classes, runs with real classes from "..
               "your project, has nginx embeded methods for openresty individual testing. Has a suite "..
               "of libraries preinstalled and you can specify libraries to install.",
    license = "MIT"
}
dependencies = {
    "luafilesystem"
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