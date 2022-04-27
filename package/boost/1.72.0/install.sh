#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh
./b2 install --prefix=$1
