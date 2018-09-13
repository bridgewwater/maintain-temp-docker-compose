#!/usr/bin/env bash
# copy right by sinlov at https://github.com/sinlov
# Licenses http://www.apache.org/licenses/LICENSE-2.0

# remove taget
remove_tag="$HOME/actDocker"

# set remove contain
remove_contain_list=(
    # dev-flask-17777
)

# set remove folder list
remove_folder_list=(
    # data/gld/tyk-gateway
)

run_path=$(pwd)
shell_run_name=$(basename $0)
shell_run_path=$(cd `dirname $0`; pwd)
# load utils-docker-maintain.sh
source ${shell_run_path}/utils-docker-maintain.sh

removeContainByList(){
    if [ ! -n "${remove_contain_list}" ];then
        pI "\n=>remove_contain_list is empty at script: ${shell_run_path}/${shell_run_name}\n"
    else
        pI "\n=>remove contain by script: ${shell_run_path}/${shell_run_name} at remove_contain_list start\n"
        for remove_contain in ${remove_contain_list[@]};
        do
            dockerRemoveContainSafe ${remove_contain}
            checkFuncBack "dockerRemoveContainSafe ${remove_contain}"
        done
        pI "\n=>remove contain by script: ${shell_run_path}/${shell_run_name} at remove_contain_list end\n"
    fi
}

# clean folder by remove_folder_list set
removeFolderByList(){
    if [ ! -n "${remove_folder_list}" ];then
        pI "\n=>remove_folder_list is empty at script: ${shell_run_path}/${shell_run_name}\n"
    else
        pI "\n=>remove folder by script: ${shell_run_path}/${shell_run_name} at remove_folder_list start\n"
        for remove_folder in ${remove_folder_list[@]};
        do
            clean_target=${remove_tag}/${remove_folder}
            if [ -d ${remove_tag}/${remove_folder} ];then
                pI "-> remove item [ ${clean_target} ] is folder"
                rm -rf ${clean_target}
                checkFuncBack "rm -rf ${clean_target}"
                pI "-> remove item [ ${clean_target} ] success"
            fi
        done
        pI "\n=>remove folder by script: ${shell_run_path}/${shell_run_name} at remove_folder_list end\n"
    fi
}

# check env
checkEnv docker
checkEnv docker-compose
# check tag
if [[ ! -d ${remove_tag} ]]; then
    pE "can not found sync tag => ${remove_tag}, exit 1"
    exit 1
else
    pV "remove target path => ${remove_tag}\n"
fi

# remove contain
removeContainByList

# remove folder
removeFolderByList