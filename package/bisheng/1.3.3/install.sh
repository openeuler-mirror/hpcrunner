#!/bin/bash
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/bisheng-compiler-1.3.3-aarch64-linux.tar.gz
cd ${JARVIS_TMP}
tar xzvf ${JARVIS_DOWNLOAD}/bisheng-compiler-1.3.3-aarch64-linux.tar.gz -C $1 --strip-components=1