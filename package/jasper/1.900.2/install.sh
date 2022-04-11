#download from https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.2.tar.gz
#!/bin/bash
set -x
set -e

cd ${JARVIS_TMP}
rm -rf jasper-1.900.2
tar -xvf ${JARVIS_DOWNLOAD}/jasper-1.900.2.tar.gz
cd jasper-1.900.2
#CC=clang CXX=clang++ 
./configure --prefix=$1
make -j
make install
