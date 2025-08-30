#!/bin/bash
CUR_PATH=$(pwd)
chmod -R +x ./benchmark
chmod -R +x ./package
chmod -R +x ./test
chmod +x ./*.sh
chmod +x jarvis
mkdir -p tmp
export JARVIS_ROOT=${CUR_PATH} #hpcrunner所在路径
export JARVIS_COMPILER=${CUR_PATH}/software/compiler
export JARVIS_MPI=${CUR_PATH}/software/mpi
export JARVIS_LIBS=${CUR_PATH}/software/libs
export JARVIS_UTILS=${CUR_PATH}/software/utils
export JARVIS_DOWNLOAD=${CUR_PATH}/downloads #应用包下载存放路径
export JARVIS_MODULES=${CUR_PATH}/software/modulefiles
export JARVIS_MODULEDEPS=${CUR_PATH}/software/moduledeps
export JARVIS_TMP=/tmp #应用安装路径
export JARVIS_TMP_DOWNLOAD=${CUR_PATH}/tmp
export JARVIS_EXE=${CUR_PATH}/exe
export JARVIS_PROXY=https://github.com #github网络代理，默认使用官方源
export UseGitee=1 #下载源是否优先使用gitee，1代表优先使用
export UseLatest=0 #依赖是否优先安装最新版，1代表优先使用

export DOWNLOAD_TOOL=${CUR_PATH}/package/common/download.sh
export CHECK_DEPS=${CUR_PATH}/package/common/check_deps.sh
export CHECK_ROOT=${CUR_PATH}/package/common/check_root.sh

export kp=neon
ifsme=`lscpu|grep sme`
ifsve=`lscpu|grep sve`
ifneon=`lscpu|grep neon`
variable="some value"
if [ -n "$ifsme" ]; then
    kp=sme
elif [ -n "$ifsve" ]; then
    kp=sve
elif [ -n "$ifneon" ]; then
    kp=neon
else
    echo "not in kunpeng architecture"
fi

#Install modules
if ! type module >/dev/null 2>&1;then
    echo "Install environment-modules"
    . $CHECK_ROOT && yum install -y environment-modules || apt install -y environment-modules
    source /etc/profile
fi
