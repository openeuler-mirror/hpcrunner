#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh --with-toolset=clang --with-libraries=iostreams,filesystem,timer,chrono,program_options,regex,system,serialization
./b2 toolset=clang cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" install --prefix=$1
