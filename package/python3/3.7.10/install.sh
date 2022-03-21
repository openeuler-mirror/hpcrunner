#!/bin/bash
set -e
cd ${JARVIS_TMP}
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
tar -zxvf ${JARVIS_DOWNLOAD}/Python-3.7.10.tgz
cd Python-3.7.10
./configure --prefix=${JARVIS_COMPILER}/python3
make
make install
ln -s ${JARVIS_COMPILER}/python3/bin/python3.7 /usr/local/bin/python3