#!/bin/bash
set -e
export bisheng_ver='BiShengCompiler-4.1.0'
arch='x86'
if [ x$(arch) = xaarch64 ];then
        arch='aarch64'
fi
# . ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/${bisheng_ver}-${arch}-linux-mini-hpc.tar.gz
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/${bisheng_ver}-${arch}-linux.tar.gz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum -y install libatomic libstdc++ libstdc++-devel
tar xzvf ${JARVIS_DOWNLOAD}/${bisheng_ver}-${arch}-linux.tar.gz -C $1 --strip-components=1
