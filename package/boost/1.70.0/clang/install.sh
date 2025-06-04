#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://archives.boost.io/release/1.70.0/source/boost_1_70_0.tar.bz2
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_70_0.tar.bz2
cd boost_1_70_0
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh --with-toolset=clang --with-libraries=system,filesystem,serialization,program_options
./b2 cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" install --prefix=$1
