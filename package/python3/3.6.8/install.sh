#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.huaweicloud.com/python/3.6.8/Python-3.6.8.tgz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
tar -zxvf ${JARVIS_DOWNLOAD}/Python-3.6.8.tgz
cd Python-3.6.8
./configure --prefix=$1 --with-ensurepip=yes CFLAGS="-O3 -Wno-implicit-function-declaration"
make
make install
