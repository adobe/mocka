echo " ... installing lua ... " \
    && curl -L  http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz -o /var/lua.tar.gz \
    && tar zxf /var/lua.tar.gz -C /var\
    && cd /var/lua-${LUA_VERSION} \
    && make linux test \
    && export PATH=${PATH}:/var/lua-${LUA_VERSION}/src \
    && ln -s /var/lua-${LUA_VERSION}/src/lua /usr/local/bin/lua