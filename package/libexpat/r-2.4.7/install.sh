#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/libexpat/libexpat/archive/refs/tags/R_2_4_7.tar.gz -f libexpat-2.4.7.tar.gz
cd ${JARVIS_TMP}
rm -rf libexpat-R_2_4_7
tar xvf ${JARVIS_DOWNLOAD}/libexpat-2.4.7.tar.gz
cd libexpat-R_2_4_7/expat
cmake . -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_INSTALL_PREFIX=$1
make -j
make install
