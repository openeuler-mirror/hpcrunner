#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/htslib-1.11.tar.bz2
cd htslib-1.11 

yum install bzip2-devel -y

autoreconf -i
./configure --prefix=$1 --host=aarch64-unknown-linux-gnu
make -j
make install
