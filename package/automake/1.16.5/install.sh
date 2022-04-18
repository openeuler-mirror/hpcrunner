#!/bin/bash

#wget https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/automake-1.16.5.tar.gz
cd automake-1.16.5
./configure --prefix=$1
make -j
make install
