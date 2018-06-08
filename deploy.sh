docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "ENV=${1}" -e "API_KEY=${API_KEY}" --privileged -i -t adobeapiplatform/luamock:latest /bin/sh ./docker/deploy.sh

version=$(cat ./dist/luarocks/.version)

curl -u atrifan:${DOCKER_KEY} https://cloud.docker.com/api/app/v1/service/
docker tag adobeapiplatform/luamock:latest adobeapiplatform/luamock:$version
docker push adobeapiplatform/luamock:$version