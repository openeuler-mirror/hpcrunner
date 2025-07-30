#!/bin/bash
set -x
set -e

wget https://codeload.github.com/djhshih/blat/tar.gz/v35.1 -O ${JARVIS_DOWNLOAD}/blat-35.1.tar.gz
yum -y install libpng-devel

cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/blat-35.1.tar.gz
cd blat-35.1/
sed -i 's/jmp_buf htmlRecover/\/\/jmp_buf htmlRecover/g' src/inc/htmshell.h
export MACHTYPE=aarch64
make