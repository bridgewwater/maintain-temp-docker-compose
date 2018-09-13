#!/usr/bin/env bash
# copy right by sinlov at https://github.com/sinlov
# Licenses http://www.apache.org/licenses/LICENSE-2.0

# sync taget
sync_tag="$HOME/actDocker"

# set clean folder list
clean_folder_list=(
    data/nginx/conf/
    data/nginx/home/ # can annotate it for close sync
    swagger-ui/
    data/Dev/flask-17777/
)
# set sync file or folder set
sync_list=(
    utils-docker-maintain.sh
    docker-compose.yml
    remove-docker-contain.sh
    maintain.sh
    data/nginx/conf/
    data/nginx/home/ # can annotate it for close sync
    swagger-ui/
    data/Dev/flask-17777/
    # data/gld/tyk-gateway/tyk.standalone.conf
)

run_path=$(pwd)
shell_run_name=$(basename $0)
shell_run_path=$(cd `dirname $0`; pwd)

source ${shell_run_path}/utils-docker-maintain.sh

# clean folder by clean_folder_list set
syncCleanFolderByList(){
    if [ ! -n "${clean_folder_list}" ];then
        pI "\n=>clean_folder_list is empty at script: ${shell_run_path}/${shell_run_name}\n"
    else
        pI "\n=>clean folder by script: ${shell_run_path}/${shell_run_name} at clean_folder_list start\n"
        for clean_folder in ${clean_folder_list[@]};
        do
            clean_target=${sync_tag}/${clean_folder}
            if [ -d ${sync_tag}/${clean_folder} ];then
                pI "-> clean item [ ${clean_target} ] is folder"
                rm -rf ${clean_target}
                checkFuncBack "rm -rf ${clean_target}"
                pI "-> clean item [ ${clean_target} ] success"
            fi
        done
        pI "\n=>clean folder by script: ${shell_run_path}/${shell_run_name} at clean_folder_list end\n"
    fi
}

# sync file or folder by sync_list set
sycnFileOrFolderByList(){
    if [ ! -n "${sync_list}" ];then
        pW "\n=>sync_list is empty at script: ${shell_run_path}/${shell_run_name}\n"
    else
        pI "\n=>sync by script: ${shell_run_path}/${shell_run_name} at sync_list start\n"
        for sync_item in ${sync_list[@]};
        do
            # just file
            if [ -f ${shell_run_path}/${sync_item} ];then
                pI "-> sync item [ ${sync_item} ] is file"
                target_path=${sync_tag}/$(findFatherFolderPath ${sync_item})
                findFolderPathIfNotJustMakeIt ${target_path}
                # pD "cp ${shell_run_path}/${sync_item} ${target_path}"
                cp ${shell_run_path}/${sync_item} ${target_path}
                checkFuncBack "cp ${shell_run_path}/${sync_item} ${target_path}"
            fi
            # just folder
            if [ -d ${shell_run_path}/${sync_item} ];then
                pI "-> sync item [ ${sync_item} ] is folder"
                target_path=${sync_tag}/${sync_item}
                findFolderPathIfNotJustMakeIt ${target_path}
                # pD "cp -R ${shell_run_path}/${sync_item} ${target_path}"
                cp -R ${shell_run_path}/${sync_item} ${target_path}
                checkFuncBack "cp -R ${shell_run_path}/${sync_item} ${target_path}"
            fi
            pI "-> sync item [ ${sync_item} ] success"
        done
        pI "\n=>sync by script: ${shell_run_path}/${shell_run_name} at sync_list end\n"
    fi
}

checkEnv docker
checkEnv docker-compose

# check sync tag start
if [[ ! -d ${sync_tag} ]]; then
    pE "can not found sync tag => ${sync_tag}, exit 1"
    exit 1
else
    pV "sync target path => ${sync_tag}\n"
fi

# check data path
if [[ ! -d "${sync_tag}/data/" ]]; then
    echo -e "make dir ${sync_tag}/data/"
    mkdir -p "${sync_tag}/data/"
fi
# check sync tag end

# sync maintain script start
pV "=> just start sync maintain script"
cp "${shell_run_path}/docker-compose.yml" "${sync_tag}/"
cp "${shell_run_path}/remove-docker-contain.sh" "${sync_tag}/"
cp "${shell_run_path}/maintain.sh" "${sync_tag}/"
sleep 1
pV "=> finish sync maintain script"
# sync maintain script end

# sync clean
syncCleanFolderByList
# sync file or folder
sycnFileOrFolderByList

pV "\n-> You can to path ${sync_tag} and run ./maintain.sh\n"


# to target maintain run ./maintain.sh
cd ${sync_tag}
if [ -f "./remove-docker-contain.sh" ];then
    ./remove-docker-contain.sh
    checkFuncBack "${sync_tag} ./remove-docker-contain.sh"
fi
if [ -f "./maintain.sh" ];then
    ./maintain.sh
    checkFuncBack "${sync_tag} ./maintain.sh"
fi
# back to run path
cd ${run_path}
