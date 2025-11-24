#!/bin/bash
set -e
set -x

install_path=$1

${DOWNLOAD_TOOL} -u https://github.com/facebook/zstd/releases/download/v1.5.0/zstd-1.5.0.tar.gz

cd ${JARVIS_TMP}

if [ -d "zstd-1.5.0" ]; then
    rm -rf zstd-1.5.0
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/zstd-1.5.0.tar.gz

cd zstd-1.5.0
make
make install prefix=$install_path
