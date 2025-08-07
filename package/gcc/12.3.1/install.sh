#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-12.3.1-2024.09-aarch64-linux.tar.gz
cd ${JARVIS_TMP}
rm -rf gcc-12.3.1
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-12.3.1-2024.09-aarch64-linux.tar.gz