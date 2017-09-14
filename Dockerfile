FROM alpine:3.4

WORKDIR /mocka_space
ARG luarocks=2.4.1
ARG lua=5.3.4

ENV LUA_ROCKS_VERSION $luarocks
ENV LUA_VERSION $lua

ADD ./docker /scripts
RUN chmod -R +x /scripts

ADD ./luacov-cobertura /tmp/mocka/luacov-cobertura
ADD ./src /tmp/mocka/src
ADD ./mocka-1.0-1.rockspec /tmp/mocka/

RUN  apk update \
        && apk add sudo curl make gcc g++ readline-dev lua5.3 lua5.3-dev

RUN /scripts/lua_rocks.sh \
    && /scripts/lua.sh \
    && /scripts/mocka.sh

RUN rm -rf /tmp/mocka

CMD "/scripts/run_tests.sh"