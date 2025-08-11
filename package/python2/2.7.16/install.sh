#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum -y install bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel libffi-devel
rm Python-2.7.16 -rf
tar -zxvf ${JARVIS_DOWNLOAD}/Python-2.7.16.tgz
cd Python-2.7.16
./configure --prefix=$1  CFLAGS="-Wno-implicit-function-declaration" --with-ensurepip=yes
make
make install
