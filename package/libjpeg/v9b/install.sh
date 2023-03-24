#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.ijg.org/files/jpegsrc.v9b.tar.gz
cd ${JARVIS_TMP}
rm -rf jpeg-9b
tar xvf ${JARVIS_DOWNLOAD}/jpegsrc.v9b.tar.gz
cd jpeg-9b
<<<<<<< HEAD
./configure --prefix=$1 CFLAGS="-fPIC"
make -j
=======
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
./configure --prefix=$1 CFLAGS="-fPIC"
>>>>>>> 82149df8cdc02c28c2c65bb5d433bc2586594f7b
make install
