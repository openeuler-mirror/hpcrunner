#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v0.3.14.tar.gz -f OpenBLAS-0.3.14.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenBLAS-0.3.14
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.14.tar.gz
cd OpenBLAS-0.3.14
make -j 
make PREFIX=$1 install
