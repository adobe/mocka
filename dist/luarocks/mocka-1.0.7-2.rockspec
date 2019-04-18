package = "mocka"
version = "1.0.7-2"
source = {
   url = "git+https://github.com/adobe/mocka.git",
   tag = "v1.0.7"
}
description = {
   summary = "The one lua testing framework that mocks classes, runs with real classes from your project, has nginx embeded methods for openresty individual testing. Has a suite of libraries preinstalled and you can specify libraries to install.",
   license = "Apache2"
}
dependencies = {
   "luafilesystem",
   "lua-websockets",
   "lua-cjson = 2.1.0",
   "lua-ev",
   "luabitop",
   "lua-resty-iputils",
   "penlight",
   "ldoc",
   "luacov",
   "luacov-coveralls",
   "luacov-cobertura",
   "luacheck",
   "lua >= 5.1"
}
build = {
   type = "builtin",
   platforms = {
      haiku = {
         modules = {
            ["luacov.cobertura.luatoxml"] = "luacov-cobertura/luacov/cobertura/luatoxml.lua",
            ["luacov.reporter.cobertura"] = "luacov-cobertura/luacov/reporter/cobertura.lua",
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.argparse"] = "src/main/lua/com/adobe/test/framework/argparse.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.output"] = "src/main/lua/com/adobe/test/framework/output.lua",
            ["mocka.require"] = "src/main/lua/com/adobe/test/framework/require_lua.lua",
            ["mocka.server"] = "src/main/lua/com/adobe/test/framework/server.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      macosx = {
         modules = {
            ["luacov.cobertura.luatoxml"] = "luacov-cobertura/luacov/cobertura/luatoxml.lua",
            ["luacov.reporter.cobertura"] = "luacov-cobertura/luacov/reporter/cobertura.lua",
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.argparse"] = "src/main/lua/com/adobe/test/framework/argparse.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.output"] = "src/main/lua/com/adobe/test/framework/output.lua",
            ["mocka.require"] = "src/main/lua/com/adobe/test/framework/require_lua.lua",
            ["mocka.server"] = "src/main/lua/com/adobe/test/framework/server.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      unix = {
         install = {
            bin = {
               mocka = "src/bin/mocka"
            }
         },
         modules = {
            ["luacov.cobertura.luatoxml"] = "luacov-cobertura/luacov/cobertura/luatoxml.lua",
            ["luacov.reporter.cobertura"] = "luacov-cobertura/luacov/reporter/cobertura.lua",
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.argparse"] = "src/main/lua/com/adobe/test/framework/argparse.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.output"] = "src/main/lua/com/adobe/test/framework/output.lua",
            ["mocka.require"] = "src/main/lua/com/adobe/test/framework/require_lua.lua",
            ["mocka.server"] = "src/main/lua/com/adobe/test/framework/server.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      }
   }
}
