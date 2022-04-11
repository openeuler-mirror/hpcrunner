#!/bin/bash
#wget https://github.com/samtools/htslib/releases/download/1.15/htslib-1.15.tar.bz2
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/htslib-1.15.tar.bz2
cd htslib-1.15 
autoreconf -i
./configure --prefix=$1
make -j
make install
