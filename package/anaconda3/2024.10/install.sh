#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-aarch64.sh
cd ${JARVIS_DOWNLOAD}
rm -rf $1
bash Anaconda3-2024.10-1-Linux-aarch64.sh -b -p $1
source $1/etc/profile.d/conda.sh
#取消每次启动自动激活conda的base基础环境
conda config --set auto_activate_base false
