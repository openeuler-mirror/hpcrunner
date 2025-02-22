#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://archives.boost.io/release/1.72.0/source/boost_1_72_0.tar.gz
cd ${JARVIS_TMP}
rm -rf boost_1_72_0
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh --with-python=`which python3`
./b2 cxxflags="$(python3-config --includes) -Wno-deprecated-builtins -Wno-enum-constexpr-conversion -fPIC" linkflags="$(python3-config --ldflags)" install --prefix=$1
