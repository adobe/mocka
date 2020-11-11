# Script parameters
TESTS_SPECIFIED=$1

function cid(){
    CID=`docker-compose -f docker-compose-integration_${GATEWAY_FLAVOUR}.yml ps -q $1`
    echo -n $CID | tee /tmp/last-cid
    `docker inspect -f "{{.State.Running}}" $CID` || kill -SIGINT $SELF_PID
}

docker-compose up -d

docker exec $(cid mocka_openresty) curl -m 10000 -H "Host: mocka.tests.io" http://localhost:9191/run-tests?tests=$TESTS_SPECIFIED