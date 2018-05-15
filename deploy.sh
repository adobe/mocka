docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "ENV=${1}" -e "API_KEY=${API_KEY}" --privileged -i -t adobeio/luamock:latest /bin/sh ./docker/deploy.sh