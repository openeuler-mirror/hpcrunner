#!/bin/bash
set -x
set -e
export mpich_ver='4.1.1'
. ${DOWNLOAD_TOOL} -u https://www.mpich.org/static/downloads/${mpich_ver}/mpich-${mpich_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf mpich-${mpich_ver}
tar -xvf ${JARVIS_DOWNLOAD}/mpich-${mpich_ver}.tar.gz
cd mpich-${mpich_ver}
./configure --prefix=$1
make -j
make install