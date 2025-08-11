#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.huaweicloud.com/python/3.7.10/Python-3.7.10.tgz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum -y install bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel libffi-devel
tar -zxvf ${JARVIS_DOWNLOAD}/Python-3.7.10.tgz
cd Python-3.7.10
./configure --prefix=$1
make
make install
#ln -s $1/python3/3.7.10/bin/python3.7 /usr/local/bin/python3
#ln -s $1/python3/3.7.10/bin/pip3.7 /usr/local/bin/pip3
