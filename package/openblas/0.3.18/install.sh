#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/xianyi/OpenBLAS/releases/download/v0.3.18/OpenBLAS-0.3.18.tar.gz
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.18.tar.gz
cd OpenBLAS-0.3.18
make -j
make PREFIX=$1 install
