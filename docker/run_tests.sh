#!/bin/sh

if [ ! -z "{$LUAROCKS_FILE}"]; then
    sudo luarocks make ${LUAROCKS_FILE}
fi

if [ ! -z "{$DEP_INSTALL}" ]; then
    for i in $(echo ${DEP_INSTALL} | sed "s/,/ /g")
    do
        # call your procedure/other scripts here below
        sudo luarocks install $i
    done
fi

if [ ! -z "{$LUA_LIBRARIES}" ]; then
    cp -r /mocka_space/${LUA_LIBRARIES}* /usr/local/share/lua/5.1/
fi

lua -lluacov run_tests.lua \
    && luacov \
    && luacov-cobertura -o coverage_report.xml