#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/git/git/archive/refs/tags/v2.35.1.tar.gz -f git-2.35.1.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/git-2.35.1.tar.gz
cd git-2.35.1
autoconf
./configure --prefix=$1
make -j
make install
#export PATH=${JARVIS_COMPILER}/git/2.35.1/bin:$PATH
