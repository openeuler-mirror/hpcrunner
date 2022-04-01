#!/bin/bash
#Download: https://go.dev/dl/
set -x
set -e
cd ${JARVIS_TMP}
file_name='go1.18.linux-arm64.tar.gz'
if [ ! -f "${JARVIS_DOWNLOAD}/${file_name}" ]; then
wget --no-check-certificate -P ${JARVIS_DOWNLOAD} https://go.dev/dl/${file_name}
fi
rm -rf /usr/local/go
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name} -C /usr/local
export PATH=/usr/local/go/bin:$PATH
