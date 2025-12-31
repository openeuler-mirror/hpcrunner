#!/bin/bash
CUR_PATH=$(pwd)
chmod -R +x ./benchmark
chmod -R +x ./package
chmod -R +x ./test
chmod +x ./*.sh
chmod +x jarvis
mkdir -p tmp

#设置hpcrunner相关环境变量
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
export UseDev=0 #确定是否使用开发者模式，1代表使用
export UseLatest=0 #依赖是否优先安装最新版，1代表优先使用
export DOWNLOAD_TOOL=${CUR_PATH}/package/common/download.sh
export CHECK_DEPS=${CUR_PATH}/package/common/check_deps.sh
export CHECK_ROOT=${CUR_PATH}/package/common/check_root.sh
export kp=neon
ifsme=`lscpu|grep sme`
ifsve=`lscpu|grep sve`
ifneon=`lscpu|grep asimd`

if [ -n "$ifsme" ]; then
    export kp=sme
elif [ -n "$ifsve" ]; then
    export kp=sve
elif [ -n "$ifneon" ]; then
    export kp=neon
else
    echo "[INFO] 当前运行环境非ARM架构"
fi

#设置依赖相关环境变量
if [ ${UseLatest} -eq 0 ];then
    export HPCKIT_VERSION=25.1.0
    export BISHENG_VERSION=4.2.0.2
    export HMPI_VERSION=25.1.0
elif [ ${UseLatest} -eq 1 ];then
    export HPCKIT_VERSION=latest
else
    echo "[ERROR] UseLatest=${UseLatest}, UseLatest只支持'0'或'1'"
    exit 1
fi


function check_network() {
    ./jarvis -net
}

#检查编译器

function check_deps() {
    ifdep=`rpm -qa|grep flex`
    if [ -n "$ifdep" ]; then
        echo "[INFO] 环境已完成基础依赖安装"
    else
        yum -y install git time zlib zlib-devel gcc gcc-c++ environment-modules python python3 python3-devel python3-libs python3-pip 
        yum -y install cmake make numactl numactl-devel numactl-libs rpmdevtools wget libtirpc libtirpc-devel unzip flex 
        yum -y install tar patch glibc-devel rpcbind csh perl-XML-LibXML xorg-x11-xauth curl curl-devel libcurl-devel
	if [ $? -ne 0 ]; then
           echo "[ERROR] 基础依赖安装失败"  
	   exit 1
	fi
    fi
}

#命令执行

check_network
check_deps


#Install modules
if ! type module >/dev/null 2>&1;then
    echo "Install environment-modules"
    . $CHECK_ROOT && yum install -y environment-modules || apt install -y environment-modules
    if [ $? -ne 0 ]; then
       echo "[ERROR] environment-modules安装失败"
       exit 1
    fi
    source /etc/profile
fi

echo "[INFO] 成功完成初始化"

