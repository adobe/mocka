FROM alpine:3.4

WORKDIR /mocka_space
ARG luarocks=2.4.1
ARG lua=5.1.4

ENV LUA_ROCKS_VERSION $luarocks
ENV LUA_VERSION $lua
ENV CGO_ENABLED=0
ENV LUA_LIBRARIES=
ENV DEP_INSTALL=
ENV LUAROCKS_FILE=
ENV API_KEY=
ENV DIST_SOURCE=./dist/luarocks
ENV PACKAGE=mocka
ENV COVERALLS_REPO_TOKEN=


ADD ./docker /scripts
RUN chmod -R +x /scripts

ADD ./ /tmp/mocka/

RUN  apk update \
        && apk add sudo curl make gcc g++ readline-dev lua5.1 lua5.1-dev git ncurses-libs libc-dev build-base git bash unzip libev libev-dev

RUN ln -s /usr/bin/lua5.1 /usr/bin/lua

RUN /scripts/lua_rocks.sh \
    && /scripts/luacheck.sh \
    && /scripts/ldoc.sh

RUN git config --global url."https://".insteadOf git://

RUN sudo luarocks install lua-cjson 2.1.0-1\
    && sudo luarocks install lua-ev \
    && sudo luarocks install luabitop \
    && sudo luarocks install lua-resty-iputils

RUN /scripts/mocka.sh

RUN rm -rf /tmp/mocka

CMD "/scripts/run_tests.sh"