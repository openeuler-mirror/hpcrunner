#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/samtools-1.11.tar.bz2
cd samtools-1.11
./configure --prefix=$1
make -j
make install
mkdir $1/include $1/lib
cp ./*.h $1/include
cp ./*.a $1/lib
