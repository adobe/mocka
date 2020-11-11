FROM centos:7

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
ENV DOCS_FOLDER=
ENV LUACHECK_PARAMS=

RUN  yum update -y \
        && yum install sudo wget curl make gcc g++ pcre-devel zlib-devel readline-devel lua-devel git geoip-devel \
        jq sudo ncurses-libs libc-dev build-base git bash unzip libev libev-devel  glibc-devel -y

#RUN ln -s /usr/bin/lua5.1 /usr/bin/lua

ADD ./docker /scripts
ADD ./ /tmp/mocka/
RUN chmod -R +x /scripts

RUN /scripts/lua_rocks.sh

RUN ln -s /usr/local/bin/luarocks /usr/bin/luarocks
RUN /scripts/luacheck.sh \
    && /scripts/ldoc.sh

RUN /scripts/openresty.sh

RUN git config --global url."https://".insteadOf git://

RUN sudo luarocks install lua-cjson 2.1.0-1\
    && sudo luarocks install lua-ev \
    && sudo luarocks install luabitop \
    && sudo luarocks install lua-resty-iputils \
    && sudo luarocks install lua-resty-http 0.13

RUN /scripts/mocka.sh

RUN rm -rf /tmp/mocka

ENV PATH="/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ADD ./nginx /usr/local/openresty/nginx/conf
RUN mkdir /var/log/nginx

CMD "/scripts/run_tests.sh"