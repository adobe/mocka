# Script parameters
TESTS_SPECIFIED=$1

function cid(){
    CID=`docker-compose -f docker-compose.yml ps -q $1`
    echo $CID | tee /tmp/last-cid
    `docker inspect -f "{{.State.Running}}" $CID` || kill -SIGINT $SELF_PID
}

echo "Running integration tests"

echo "local modules = {" > coverage_modules.lua
find . -name '*.lua' | while read line; do
    filename="$(basename $line)"
    filename="${filename%.*}"
    echo "\t ['$filename'] = '${line:2}'," >> coverage_modules.lua
done
echo "} \nreturn { modules = modules }" >> coverage_modules.lua

docker-compose up -d

docker exec $(cid mocka_openresty) curl -m 10000 -H "Host: mocka.tests.io" http://localhost:9191/run-tests?tests=$TESTS_SPECIFIED

docker exec $(cid mocka_openresty) bash -c "/usr/local/bin/luacov-cobertura -c config_cobertura.lua -o coverage_report.xml"

docker-compose kill
docker-compose rm -f