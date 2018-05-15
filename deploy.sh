docker run -v $PWD:/mocka_space \
   -e "LUA_LIBRARIES=src/main/lua/" -e "API_KEY=$API_KEY" --entrypoint './docker/deploy.sh' $1  --privileged -i adobe/luamock:latest