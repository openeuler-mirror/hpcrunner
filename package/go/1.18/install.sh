#!/bin/bash
#Download: https://go.dev/dl/
set -x
set -e
cd ${JARVIS_TMP}
if [ ! -f "go1.18.linux-arm64.tar.gz" ]; then
wget https://go.dev/dl/go1.18.linux-arm64.tar.gz
fi
rm -rf /usr/local/go
tar -xzvf go1.18.linux-arm64.tar.gz -C /usr/local
export PATH=/usr/local/go/bin:$PATH
