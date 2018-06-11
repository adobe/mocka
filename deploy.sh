docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "ENV=${1}" -e "API_KEY=${API_KEY}" --privileged -i -t adobeapiplatform/luamock:latest /bin/sh ./docker/deploy.sh

version=$(cat ./dist/luarocks/.version)

docker login --username atrifan --password ${DOCKER_KEY}
docker tag adobeapiplatform/luamock:latest adobeapiplatform/luamock:$version
docker push adobeapiplatform/luamock:$version
docker push adobeapiplatform/luamock:latest