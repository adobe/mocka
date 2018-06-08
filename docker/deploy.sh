version=$(cat ./dist/luarocks/.version)
if [ ! -f ./dist/luarocks/${PACKAGE}-$version.rockspec ]; then
    cd ./dist/luarocks
    luarocks new_version ${PACKAGE}* --tag=v$version $version
    cd ../../
fi

if [ "$ENV" == "snapshot" ]; then
    luarocks upload ${DIST_SOURCE}/${PACKAGE}-$version.rockspec --api-key=${API_KEY} --skip-pack --force
else
    luarocks upload ${DIST_SOURCE}/${PACKAGE}-$version.rockspec --skip-pack --api-key=${API_KEY} --force
fi
