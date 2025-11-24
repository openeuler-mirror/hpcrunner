#!/bin/bash
set -x
set -e
file_name=kunpeng-hpc-1.0.0-aarch64-linux
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/Kunpeng_SDK/HPC/${file_name}.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/${file_name}.tar.gz
cd ${file_name}/script
./install.sh