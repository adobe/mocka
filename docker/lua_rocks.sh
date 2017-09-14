echo " ... installing luarocks..." \
    && curl -L https://luarocks.org/releases/luarocks-${LUA_ROCKS_VERSION}.tar.gz -o /tmp/luarocks.tar.gz \
    && tar xf /tmp/luarocks.tar.gz -C /tmp/ \
    && cd /tmp/luarocks-${LUA_ROCKS_VERSION} \
    && ./configure \
    && sudo make bootstrap
