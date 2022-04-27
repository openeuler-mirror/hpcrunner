#download from https://github.com/opencv/opencv/archive/refs/tags/4.5.5.tar.gz
#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u https://github.com/opencv/opencv/archive/refs/tags/4.5.5.tar.gz -f opencv-4.5.5.tar.gz
cd ${JARVIS_TMP}
rm -rf opencv-4.5.5
tar -xvf ${JARVIS_DOWNLOAD}/opencv-4.5.5.tar.gz
cd opencv-4.5.5
mkdir build && cd build
#export CC=clang CXX=clang++ FC=flang 
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install
