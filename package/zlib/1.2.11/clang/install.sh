#!/bin/bash
set -x
set -e
zlib_ver='1.2.11'
. ${DOWNLOAD_TOOL} -u https://zlib.net/fossils/zlib-${zlib_ver}.tar.gz
cd ${JARVIS_TMP}
<<<<<<< HEAD
=======
rm -rf zlib-${zlib_ver}
>>>>>>> 82149df8cdc02c28c2c65bb5d433bc2586594f7b
tar -xvf ${JARVIS_DOWNLOAD}/zlib-${zlib_ver}.tar.gz
cd zlib-${zlib_ver}
./configure --prefix=$1 FCFLAGS="-O3 -fPIC"
make -j
make install
