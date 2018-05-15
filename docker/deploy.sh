version=$(cat ./dist/luarocks/.version)
if [ ! -f ./dist/luarocks/mocka-$version.rockspec ]; then
    cd ./dist/luarocks
    luarocks new_version mocka* --tag=v$version $version
    cd ../../
fi

if [ "$1" == "snapshot" ]; then
    echo "yes"
    luarocks upload ./dist/luarocks/mocka-$version.rockspec --api-key=${API_KEY} --server=https://luarocks.org/dev --force
else
    luarocks upload ./dist/luarocks/mocka-$version.rockspec --api-key=${API_KEY}
fi
