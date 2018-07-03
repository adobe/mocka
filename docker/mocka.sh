cd /tmp/mocka
version=$(cat ./dist/luarocks/.version)
echo "... installing mocka luacov and luacov-coberutra ..." \
    && sudo luarocks make ${DIST_SOURCE}/${PACKAGE}-$version.rockspec