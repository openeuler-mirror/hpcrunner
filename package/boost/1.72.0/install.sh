#!/bin/bash
#wget https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh --with-toolset=clang
./b2 install --prefix=$1
