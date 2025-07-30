#!/bin/bash
set -x
set -e


wget https://github.com/deeptools/deepTools/archive/refs/tags/3.5.1.tar.gz -O ${JARVIS_DOWNLOAD}/deepTools-3.5.1.tar.gz
yum -y install doxygen cmake
yum install wget git tar libatomic git openssl glibc-devel libstdc++-static make perl cmake fuse-devel libxml2-devel file-devel patch -y

cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/deepTools-3.5.1.tar.gz

cd deepTools-3.5.1
python3 setup.py install