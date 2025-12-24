#!/bin/bash
if [[ $UseDev -eq 1 ]]; then
    set -x
else
    set +x
fi
set -e
#hpckit_ver="24.0.RC1"
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/HPC/HPCKit/HPCKit_${hpckit_ver}_Linux-aarch64.tar.gz

cd $JARVIS_TMP
if [ ! -d HPCKit_${hpckit_ver}_Linux-aarch64 ];then
   tar xvf $JARVIS_DOWNLOAD/HPCKit_${hpckit_ver}_Linux-aarch64.tar.gz
fi
cd HPCKit_${hpckit_ver}_Linux-aarch64
sh install.sh -y --prefix=$1

software_path="$1/../../.."
if [ ! -d ${software_path}/modulefiles/hpckit${hpckit_ver} ];then
    ln -s $1/HPCKit/latest/modulefiles ${software_path}/modulefiles/hpckit${hpckit_ver}
    
    hmpi_file_list=`grep -R "\"Huawei Hyper MPI\"" $1/HPCKit/latest/modulefiles |awk -F':' '{print $1}'`
    for hmpi_file in ${hmpi_file_list}
    do
            echo -e "\nsetenv CC mpicc \nsetenv CXX mpicxx \nsetenv FC mpifort \nsetenv F77 mpifort \nsetenv F90 mpifort " >> ${hmpi_file}
    done
fi

export HPCKIT_VERSION=${hpckit_ver}
file_path="${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/modulefiles/bisheng"
export BISHENG_VERSION=`ls $file_path|grep compiler|awk -F "compiler" '{print $2}'`
export HMPI_VERSION=`ls $file_path|grep hmpi|awk -F "hmpi" '{print $2}'`

echo -e "HPCKit has installed in your environment."
echo -e "你正在使用 $HPCKIT_VERSION 版本的 HPCKKit"