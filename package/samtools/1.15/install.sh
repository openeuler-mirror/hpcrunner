#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/samtools-1.15.tar.bz2
cd samtools-1.15
./configure --prefix=$1
make -j
make install
