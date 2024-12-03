#!/bin/bash
CUR_PATH=$(pwd)
chmod -R +x ./benchmark
chmod -R +x ./package
chmod -R +x ./test
chmod +x ./*.sh
chmod +x jarvis
mkdir -p tmp
export JARVIS_ROOT=${CUR_PATH}
export JARVIS_COMPILER=${CUR_PATH}/software/compiler
export JARVIS_MPI=${CUR_PATH}/software/mpi
export JARVIS_LIBS=${CUR_PATH}/software/libs
export JARVIS_UTILS=${CUR_PATH}/software/utils
export JARVIS_DOWNLOAD=${CUR_PATH}/downloads
export JARVIS_MODULES=${CUR_PATH}/software/modulefiles
export JARVIS_MODULEDEPS=${CUR_PATH}/software/moduledeps
export JARVIS_TMP=/tmp
export JARVIS_TMP_DOWNLOAD=${CUR_PATH}/tmp
export JARVIS_EXE=${CUR_PATH}/exe
export JARVIS_PROXY=https://gh.ddlc.top/https://github.com



export DOWNLOAD_TOOL=${CUR_PATH}/package/common/download.sh
export CHECK_DEPS=${CUR_PATH}/package/common/check_deps.sh
export CHECK_ROOT=${CUR_PATH}/package/common/check_root.sh

#Install modules
if ! type module >/dev/null 2>&1;then
    echo "Install environment-modules"
    . $CHECK_ROOT && yum install -y environment-modules || apt install -y environment-modules
    source /etc/profile
fi
