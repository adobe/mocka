#!/bin/sh

if [ ! -z "{$LUA_LIBRARIES}" ]; then
    cp -r /mocka_space/${LUA_LIBRARIES}* /usr/local/share/lua/5.1/
fi

lua -lluacov run_tests.lua \
    && luacov \
    && luacov-cobertura -o coverage_report.xml