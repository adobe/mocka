FROM alpine:3.4

WORKDIR /mocka_space
ARG luarocks=2.4.1
ARG lua=5.1.4

ENV LUA_ROCKS_VERSION $luarocks
ENV LUA_VERSION $lua
ENV CGO_ENABLED=0
ENV LUA_LIBRARIES=

ADD ./docker /scripts
RUN chmod -R +x /scripts

ADD ./luacov-cobertura /tmp/mocka/luacov-cobertura
ADD ./src /tmp/mocka/src
ADD ./mocka-1.0-1.rockspec /tmp/mocka/

RUN  apk update \
        && apk add sudo curl make gcc g++ readline-dev lua5.1 lua5.1-dev git ncurses-libs libc-dev build-base git bash unzip

RUN ln -s /usr/bin/lua5.1 /usr/bin/lua

RUN /scripts/lua_rocks.sh \
    && /scripts/mocka.sh

RUN git config --global url."https://".insteadOf git://

RUN sudo luarocks install jsonpath \
    && sudo luarocks install lua-cjson 1.0.1-1\
    && sudo luarocks install luabitop \
    && sudo luarocks install lua-resty-iputils

RUN rm -rf /tmp/mocka

CMD "/scripts/run_tests.sh"