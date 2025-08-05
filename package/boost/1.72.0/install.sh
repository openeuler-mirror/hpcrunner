#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.gz
#. ${DOWNLOAD_TOOL} -u https://archives.boost.io/release/1.72.0/source/boost_1_72_0.tar.gz
#https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz
cd ${JARVIS_TMP}
rm -rf boost_1_72_0
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh
./b2 install --prefix=$1
