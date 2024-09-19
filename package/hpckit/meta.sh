#!/bin/bash
set -x
set -e
#hpckit_ver="24.0.RC1"
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/HPC/HPCKit/HPCKit_${hpckit_ver}_Linux-aarch64.tar.gz

cd $JARVIS_TMP
if [ ! -d HPCKit_${hpckit_ver}_Linux-aarch64 ];then
   tar xvf $JARVIS_DOWNLOAD/HPCKit_${hpckit_ver}_Linux-aarch64.tar.gz
fi
cd HPCKit_${hpckit_ver}_Linux-aarch64
sh install.sh -y --prefix=$1
echo -e "HPCKit has installed in your environment."
#useage:
#1.source software/utils/hpckit/2024.3.30/HPCKit/latest/setvars.sh --use-bisheng
#2.module purge
#module use software/utils/hpckit/2024.3.30/HPCKit/24.3.30/modulefiles
#module load bisheng/compiler/bishengmodule bisheng/kml/omp
