#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz
cd ${JARVIS_TMP}
rm -rf gcc-9.3.0
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-9.3.0.tar.gz
cd gcc-9.3.0
sed -i "35s/ftp/http/g" ./contrib/download_prerequisites
./contrib/download_prerequisites
./configure --disable-multilib --enable-languages="c,c++,fortran" --prefix=$1 --disable-static --enable-shared
make -j && make install
