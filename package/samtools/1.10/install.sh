#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/samtools-1.10.tar.bz2
cd samtools-1.10
./configure --prefix=$1
make all all-htslib
make install install-htslib
mkdir $1/include/bam
cp *.h $1/include/bam
cp *.a $1/lib

