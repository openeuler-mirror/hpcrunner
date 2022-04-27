#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/automake-1.16.5.tar.gz
cd automake-1.16.5
./configure --prefix=$1
make -j
make install
