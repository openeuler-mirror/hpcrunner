#!/bin/bash
#Download: https://go.dev/dl/
set -x
set -e
cd ${JARVIS_TMP}
# check Arch
if [ x$(arch) = xaarch64 ];then
    file_name='go1.18.linux-arm64.tar.gz'
else
    file_name='go1.18.linux-amd64.tar.gz'
fi
. ${DOWNLOAD_TOOL} -u  https://go.dev/dl/${file_name}
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name} -C $1