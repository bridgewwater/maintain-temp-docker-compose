#!/usr/bin/env bash
# copy right by sinlov at https://github.com/sinlov
# Licenses http://www.apache.org/licenses/LICENSE-2.0

pV(){
    echo -e "\033[;36m$1\033[0m"
}
pI(){
    echo -e "\033[;32m$1\033[0m"
}
pD(){
    echo -e "\033[;34m$1\033[0m"
}
pW(){
    echo -e "\033[;33m$1\033[0m"
}
pE(){
    echo -e "\033[;31m$1\033[0m"
}

checkFuncBack(){
    if [ ! $? -eq 0 ]; then
        echo -e "\033[;31mRun [ $1 ] error exit code 1\033[0m"
        exit 1
        # else
        # echo -e "\033[;30mRun [ $1 ] success\033[0m"
    fi
}

checkEnv(){
    evn_checker=`which $1`
    checkFuncBack "which $1"
    if [ ! -n "evn_checker" ]; then
        echo -e "\033[;31mCheck event [ $1 ] error exit\033[0m"
        exit 1
        # else
        #   echo -e "\033[;32mCli [ $1 ] event check success\033[0m\n-> \033[;34m$1 at Path: ${evn_checker}\033[0m"
    fi
}

checkUserAsRoot(){
    if [[ "$USER" != "root" ]]; then
        echo -e "\033[;31mMust run as root\033[0m"
        exit 1
    fi
}

findFatherFolderPath(){
    echo -n $1 | xargs dirname
}

findSecondFatherFolderPath(){
    findFatherFolderPath $(findFatherFolderPath $1)
}

findFolderPathIfNotJustMakeIt(){
    find_path=$(echo -n $1)
    if [ ! -d ${find_path} ];then
        pI "-> not find folder path\n-> mkdir path: ${find_path}"
        mkdir -p ${find_path}
        checkFuncBack "mkdir -p ${find_path}"
    fi
}

dockerIsHasContainByName(){
    if [ ! -n $1 ]; then
        pW "Want find contain is empty"
        echo "-1"
    else
        c_status=$(docker inspect $1)
        if [ ! $? -eq 0 ]; then
            echo "1"
        else
            echo "0"
        fi
    fi
}

dockerStopContainWhenRunning(){
    if [ ! -n $1 ]; then
        pW "Want stop contain is empty"
    else
        c_status=$(docker inspect --format='{{ .State.Status}}' $1)
        if [ "running" == ${c_status} ]; then
            pD "-> docker stop contain [ $1 ]"
            docker stop $1
            checkFuncBack "docker stop $1"
        fi
    fi
}

dockerRestartContainWhenRunning(){
    if [ ! -n $1 ]; then
        pW "Want restart contain is empty"
    else
        c_status=$(docker inspect --format='{{ .State.Status}}' $1)
        if [ "running" == ${c_status} ]; then
            pD "-> restart contain [ $1 ]"
            docker restart $1
            checkFuncBack "docker restart $1"
        fi
    fi
}

dockerRemoveContainSafe(){
    if [ ! -n $1 ]; then
        pW "Want remove contain is empty"
    else
        has_contain=$(dockerIsHasContainByName $1)
        if [ ${has_contain} -eq 0 ];then
            dockerStopContainWhenRunning $1
            c_status=$(docker inspect --format='{{ .State.Status}}' $1)
            if [ "exited" == ${c_status} ]; then
                pD "-> docker rm contain [ $1 ]"
                docker rm $1
                checkFuncBack "docker rm $1"
            fi
        else
            pE "dockerRemoveContainSafe Not found contain [ $1 ]"
        fi
    fi
}
