#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh --with-toolset=clang --with-libraries=system,serialization,program_options
./b2 toolset=clang cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" install --prefix=$1