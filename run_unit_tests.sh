#!/usr/bin/env bash
docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" --privileged -i adobeio/luamock:latest