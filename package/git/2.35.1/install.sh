#!/bin/bash
#wget https://github.com/git/git/archive/refs/tags/v2.35.1.tar.gz -O git-2.35.1.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/git-2.35.1.tar.gz
cd git-2.35.1
autoconf
./configure --prefix=$1
make -j
make install
#export PATH=${JARVIS_COMPILER}/git/2.35.1/bin:$PATH
