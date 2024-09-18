#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/automake-1.17.tar.gz
cd automake-1.17
./configure --prefix=$1
make -j
make install