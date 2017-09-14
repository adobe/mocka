`sudo luarocks make mocka-1.0-1.rockspec`

`luarocks install luacov`

`cp luacov-cobertura/bin/luacov-cobertura /usr/local/bin/loacov-cobertura`

`lua -lluacov run_tests.lua`

`luacov`

`luacov-cobertura -o coverage_report.xml`
