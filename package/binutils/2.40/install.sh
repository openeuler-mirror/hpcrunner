#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.aliyun.com/gnu/binutils/binutils-2.40.tar.gz -f binutils-2.40.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/binutils-2.40.tar.gz
cd binutils-2.40
./configure --prefix=$1 --enable-ld=yes --with-static-standard-libraries --enable-install-libbfd CFLAGS="-fPIC" CXXFLAGS="-fPIC" FCFLAGS="-fPIC" FFLAGS="-fPIC"
make
make install
