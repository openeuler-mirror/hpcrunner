#!/bin/bash
CUR_PATH=$(pwd)
chmod -R +x ./benchmark
#chmod -R +x ./package
chmod -R +x ./test
chmod +x ./*.sh
chmod +x jarvis
mkdir -p tmp
export JARVIS_ROOT=${CUR_PATH}
export JARVIS_SOFT_ROOT=$JARVIS_ROOT/share/software
export JARVIS_MODE=1
if [ "$JARVIS_MODE" -eq 0 ]; then
    #professional mode:Clustered Directory Structure
    export JARVIS_COMPILER=${JARVIS_SOFT_ROOT}/compiler
    export JARVIS_MPI=${JARVIS_SOFT_ROOT}/mpi
    export JARVIS_LIBS=${JARVIS_SOFT_ROOT}/libs
    export JARVIS_UTILS=${JARVIS_SOFT_ROOT}/utils
    export JARVIS_MODULES=${JARVIS_SOFT_ROOT}/modulefiles
    export JARVIS_MODULEDEPS=${JARVIS_SOFT_ROOT}/moduledeps
    export JARVIS_MISC=${JARVIS_SOFT_ROOT}/misc
    export JARVIS_APP=${JARVIS_SOFT_ROOT}/app
    export JARVIS_MODULES_APP=${JARVIS_SOFT_ROOT}/modulefiles/app
elif [ "$JARVIS_MODE" -eq 1 ]; then
    #normal mode: Flat Directory Structure
    export JARVIS_COMPILER=${JARVIS_SOFT_ROOT}/soft/compiler
    export JARVIS_MPI=${JARVIS_SOFT_ROOT}/soft/mpi
    export JARVIS_LIBS=${JARVIS_SOFT_ROOT}/soft/lib
    export JARVIS_UTILS=${JARVIS_SOFT_ROOT}/soft/tool
    export JARVIS_MODULES=${JARVIS_SOFT_ROOT}/modulefile
    export JARVIS_MODULEDEPS=${JARVIS_SOFT_ROOT}/moduledeps
    export JARVIS_MISC=${JARVIS_SOFT_ROOT}/soft/misc
    export JARVIS_APP=${JARVIS_SOFT_ROOT}/soft/app
    export JARVIS_MODULES_LIB=${JARVIS_SOFT_ROOT}/modulefile/lib
    export JARVIS_MODULES_UTIL=${JARVIS_SOFT_ROOT}/modulefile/tool
    export JARVIS_MODULES_COMPILER=${JARVIS_SOFT_ROOT}/modulefile/compiler
    export JARVIS_MODULES_MPI=${JARVIS_SOFT_ROOT}/modulefile/mpi
    export JARVIS_MODULES_LIB=${JARVIS_SOFT_ROOT}/modulefile/lib
    export JARVIS_MODULES_MISC=${JARVIS_SOFT_ROOT}/modulefile/misc
    export JARVIS_MODULES_APP=${JARVIS_SOFT_ROOT}/modulefile/app
    export JARVIS_MODULES_MODS=${JARVIS_SOFT_ROOT}/modulefile/modules
    export JARVIS_JOBSCRIPT=${JARVIS_SOFT_ROOT}/jobscript
fi
export JARVIS_TMP=/tmp
export JARVIS_DOWNLOAD=${CUR_PATH}/downloads
export JARVIS_TMP_DOWNLOAD=${CUR_PATH}/tmp
export JARVIS_EXE=${CUR_PATH}/exe
export JARVIS_TPL=${CUR_PATH}/template
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
