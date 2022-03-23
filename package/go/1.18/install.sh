#!/bin/bash
#Download: https://go.dev/dl/
set -x
set -e
cd ${JARVIS_TMP}
rm -rf /usr/local/go
tar -xzvf ${JARVIS_DOWNLOAD}/go1.18.linux-arm64.tar.gz -C /usr/local
