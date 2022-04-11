#download from https://sourceforge.net/projects/opengrads/files/grads2/2.0.a4-1/grads-2.0.a4.oga.1-src.tar.gz
#!/bin/bash
set -x
set -e

cd ${JARVIS_TMP}
rm -rf grads-2.0.a4.oga.1-src.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/grads-2.0.a4.oga.1-src.tar.gz
cd grads-2.0.a4.oga.1
#CC=clang CXX=clang++ 
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
make -j
make install
