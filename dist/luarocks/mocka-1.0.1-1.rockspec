package = "mocka"
version = "1.0.1-1"
source = {
   url = "git+https://github.com/adobe/mocka.git",
   tag = "v1.0.1"
}
description = {
   summary = "The one lua testing framework that mocks classes, runs with real classes from your project, has nginx embeded methods for openresty individual testing. Has a suite of libraries preinstalled and you can specify libraries to install.",
   license = "Apache2"
}
dependencies = {
   "luafilesystem", "lua-websockets", "lua-cjson = 2.1.0", "lua-ev", "luabitop", "lua-resty-iputils", "penlight", "ldoc", "luacov", "luacov-coveralls", "luacov-cobertura", "luacheck"
}
build = {
   type = "builtin",
   platforms = {
      haiku = {
         modules = {
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      macosx = {
         modules = {
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      mingw32 = {
         modules = {
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      unix = {
         modules = {
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      },
      win32 = {
         modules = {
            mocka = "src/main/lua/com/adobe/test/framework/Mocka.lua",
            ["mocka.debugger"] = "src/main/lua/com/adobe/test/framework/debugger.lua",
            ["mocka.default_mocks"] = "src/main/lua/com/adobe/test/framework/default_mocks.lua",
            ["mocka.http_util"] = "src/main/lua/com/adobe/test/framework/http_util.lua",
            ["mocka.messaging_queue"] = "src/main/lua/com/adobe/test/framework/messaging_queue.lua",
            ["mocka.ngx_suite"] = "src/main/lua/com/adobe/test/suites/run_ngx_tests.lua",
            ["mocka.suite"] = "src/main/lua/com/adobe/test/suites/run_tests.lua",
            ["mocka.ws_server"] = "src/main/lua/com/adobe/test/framework/ws_server.lua"
         }
      }
   }
}
