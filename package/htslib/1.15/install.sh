#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/htslib/releases/download/1.15/htslib-1.15.tar.bz2
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/htslib-1.15.tar.bz2
cd htslib-1.15 
autoreconf -i
./configure --prefix=$1
make -j
make install
