#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-9.3.1-2021.03-aarch64-linux.tar.gz
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-9.3.1-2021.03-aarch64-linux.tar.gz -C $1 --strip-components=1