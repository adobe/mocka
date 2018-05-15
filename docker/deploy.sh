version=$(cat ./dist/luarocks/.version)
if [ ! -f ./dist/luarocks/mocka-$version.rockspec ]; then
    cd ./dist/luarocks
    luarocks new_version mocka* --tag=v$version $version
    cd ../../
fi

if [ "$ENV" == "snapshot" ]; then
    luarocks upload ./dist/luarocks/mocka-$version.rockspec --api-key=${API_KEY} --skip-pack --force
else
    luarocks upload ./dist/luarocks/mocka-$version.rockspec --skip-pack --api-key=${API_KEY} --force
fi
