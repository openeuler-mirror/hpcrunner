#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-10.3.1-2022.06-aarch64-linux.tar.gz
cd ${JARVIS_TMP}
rm -rf gcc-10.3.1
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-10.3.1-2022.06-aarch64-linux.tar.gz
