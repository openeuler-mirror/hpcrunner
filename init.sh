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
    echo "not in kunpeng architecture"
fi

#设置依赖相关环境变量
if [ ${UseLatest} -eq 0 ];then
    export HPCKIT_VERSION=25.1.0
    export BISHENG_VERSION=4.2.0.2
    export HMPI_VERSION=25.1.0
elif [ ${UseLatest} -eq 1 ];then
    export HPCKIT_VERSION=latest
else
    echo "[ERROR] UseLatest=${UseLatest}, unsupported value."
    exit 1
fi

function load_hpckit() {
    export BISHENG_VERSION=`ls $file_path|grep compiler|awk -F "compiler" '{print $2}'`
    export HMPI_VERSION=`ls $file_path|grep hmpi|awk -F "hmpi" '{print $2}'`
    module use ${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/modulefiles
    module load bisheng/compiler${BISHENG_VERSION}/bishengmodule
    module load bisheng/hmpi${HMPI_VERSION}/release
    module load bisheng/kml${HMPI_VERSION}/kml > /dev/null 2>&1
    export HPCKIT_PATH=${JARVIS_UTILS}/hpckit/${HMPI_VERSION}
    export KML_LIB_PATH=${HPCKIT_PATH}/HPCKit/${HMPI_VERSION}/kml/bisheng/lib
    export KML_PATH=${HPCKIT_PATH}/HPCKit/${HMPI_VERSION}/kml
    echo -e "已自动加载毕昇编译器、Hyper-MPI和鲲鹏数学库："
    module li
}

function check_hpckit() {
    #判断hpckit是否安装，更新配套版本
    file_path="${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/modulefiles/bisheng"
    if [ -e "$file_path" ]; then
        echo -e "你正在使用 $HPCKIT_VERSION 版本的 HPCKit"
        load_hpckit
    else
        echo -e "INFO: 检测到未安装 $HPCKIT_VERSION 版本的 HPCKit，请依次执行以下命令安装："
        echo -e "./jarvis -use templates/basic_env/data.hpckit.config\n./jarvis -dp"
    fi
}

function check_network() {
    curl -s --head --request GET https://gitee.com > /dev/null
    if [ $? -ne 0 ]; then
        echo "[WARNNING] 当前网络异常，无法连接gitee，请检查网络"
    fi
}

#检查编译器
function check_com() {
    if [ -e ".meta" ]; then
        ifclang=`cat .meta | awk -F '/' 'END{print $NF}'|grep clang`
        ifgcc=`cat .meta | awk -F '/' 'END{print $NF}'|grep gcc`
        if [ -n "$ifclang" ]; then
            return 1
        elif [ -n "$ifgcc" ]; then
            return 2
        else
            return 0
        fi
    fi
}
function check_deps() {
    ifdep=`rpm -qa|grep flex`
    if [ -n "$ifdep" ]; then
        echo "[INFO] deps are installed"
    else
        yum -y install git time zlib zlib-devel gcc gcc-c++ environment-modules python python3 python3-devel python3-libs python3-pip 
        yum -y install cmake make numactl numactl-devel numactl-libs rpmdevtools wget libtirpc libtirpc-devel unzip flex 
        yum -y install tar patch glibc-devel rpcbind csh perl-XML-LibXML xorg-x11-xauth curl curl-devel libcurl-devel
    fi
}

#命令执行

check_network
check_deps


#Install modules
if ! type module >/dev/null 2>&1;then
    echo "Install environment-modules"
    . $CHECK_ROOT && yum install -y environment-modules || apt install -y environment-modules
    source /etc/profile
fi
