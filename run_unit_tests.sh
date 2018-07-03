#!/usr/bin/env bash
docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN}" --privileged -i adobeapiplatform/luamock:latest