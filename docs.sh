docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" --privileged -i -t adobeapiplatform/luamock:latest /bin/sh /scripts/generate_docs.sh
