#!/bin/bash
set -x
set -e
amg_ver='1.2'
. ${DOWNLOAD_TOOL} -u https://github.com/LLNL/AMG/archive/refs/tags/${amg_ver}.zip
cd ${JARVIS_ROOT}
rm -rf AMG-${amg_ver}
unzip ${JARVIS_DOWNLOAD}/${amg_ver}.zip
cd AMG-${amg_ver} 
make -j
mkdir $1/bin -p
cp ./test/* $1/bin
