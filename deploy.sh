docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "ENV=${1}" -e "API_KEY=${API_KEY}" --privileged -i -t adobeapiplatform/mocka:latest /bin/sh /scripts/deploy.sh

version=$(cat ./dist/luarocks/.version)

docker login --username atrifan --password ${DOCKER_KEY}
docker tag adobeapiplatform/mocka:latest adobeapiplatform/mocka:$version
docker push adobeapiplatform/mocka:$version
docker push adobeapiplatform/mocka:latest