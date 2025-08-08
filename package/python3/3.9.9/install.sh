#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.huaweicloud.com/python/3.9.9/Python-3.9.9.tgz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum -y install bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel libffi-devel
tar -zxvf ${JARVIS_DOWNLOAD}/Python-3.9.9.tgz
cd Python-3.9.9
./configure --prefix=$1 --with-ensurepip=yes CFLAGS="-O3 -Wno-implicit-function-declaration"
make
make install
