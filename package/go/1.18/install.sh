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
rm -rf /usr/local/go
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name} -C /usr/local
export PATH=/usr/local/go/bin:$PATH