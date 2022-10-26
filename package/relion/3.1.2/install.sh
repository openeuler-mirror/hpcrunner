#download from https://github.com/3dem/relion/archive/refs/tags/3.1.2.tar.gz relion-3.1.2.tar.gz
#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u  https://github.com/3dem/relion/archive/refs/tags/3.1.2.tar.gz relion-3.1.2.tar.gz
cd ${JARVIS_TMP}
rm -rf relion-3.1.2 
tar -xvf ${JARVIS_DOWNLOAD}/relion-3.1.2.tar.gz
cd relion-3.1.2
mkdir build && cd build
#. $CHECK_ROOT && yum install -y libtiff-* fltk* fltk-devel*
#yum -y install xorg-x11-xauth
#export CC=clang CXX=clang++ FC=flang
cmake -DCUDA=OFF  -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=release  -DCMAKE_INSTALL_PREFIX=$1  ..
make -j
make install
