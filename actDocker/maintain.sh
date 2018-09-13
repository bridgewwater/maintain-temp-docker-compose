#!/usr/bin/env bash
# copy right by sinlov at https://github.com/sinlov
# Licenses http://www.apache.org/licenses/LICENSE-2.0

run_path=$(pwd)
shell_run_name=$(basename $0)
shell_run_path=$(cd `dirname $0`; pwd)
# load utils-docker-maintain.sh
source ${shell_run_path}/utils-docker-maintain.sh

# check env start
# checkUserAsRoot
checkEnv docker
checkEnv docker-compose
docker version
# check env end

# update new docker-compose start
pI "=> maintain docker at $(pwd) start"
# check compose file
docker-compose config -q
checkFuncBack "docker-compose config -q"
# for kong first run
# docker-compose run kongCore kong migrations up
docker-compose up -d
checkFuncBack "docker-compose up -d"
# update new docker-compose end

# stop
pW "\nStop some contain start"
# dockerStopContainWhenRunning go-httpbin
# checkFuncBack "dockerStopContainWhenRunning go-httpbin"
pW "\nStop some contain end"

# restart
pW "\nRestart some contain start"
dockerRestartContainWhenRunning nginx
# dockerRestartContainWhenRunning go-httpbin
# checkFuncBack "dockerRestartContainWhenRunning go-httpbin"
pW "\nRestart some contain end"

pI "\n=> maintain docker at $(pwd) finish"
