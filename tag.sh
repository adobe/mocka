version=$(cat ./dist/luarocks/.version)

git tag v$version -m "v$version"
git push origin --tags

IFS='.' read -r -a array <<< "$version"
replaceable=${array[${#array[@]}-1]}
IFS='-' read -r -a array <<< "$replaceable"
incrementer=${array[0]}
incrementer=$[ $incrementer + 1 ]
luarocks_version="${array[1]}"
new_version=${version/$replaceable/$incrementer-$luarocks_version}
echo $new_version > ./dist/luarocks/.version
git add ./dist/luarocks/.version
git commit -m "[automation] next development iteration"
git push