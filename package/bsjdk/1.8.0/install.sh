#!/bin/bash
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_jdk/bisheng-jdk-8u412-linux-aarch64.tar.gz
cd ${JARVIS_TMP}
tar xzvf ${JARVIS_DOWNLOAD}/bisheng-jdk-8u412-linux-aarch64.tar.gz -C $1 --strip-components=1
