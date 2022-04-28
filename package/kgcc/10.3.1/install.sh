#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-10.3.1-2021.09-aarch64-linux.tar.gz
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-10.3.1-2021.09-aarch64-linux.tar.gz -C $1 --strip-components=1
