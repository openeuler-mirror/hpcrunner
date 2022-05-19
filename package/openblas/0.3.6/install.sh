#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.6.tar.gz -f OpenBLAS-0.3.6.tar.gz
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.6.tar.gz
cd OpenBLAS-0.3.6
make -j 
make PREFIX=$1 install
