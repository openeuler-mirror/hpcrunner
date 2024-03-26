#!/bin/bash
set -x
set -e
ver="0.3.24"
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v${ver}.tar.gz -f OpenBLAS-${ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenBLAS-${ver}
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-${ver}.tar.gz
cd OpenBLAS-${ver}
make -j 16
make PREFIX=$1 install
