#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/htslib-1.21.tar.bz2
yum install -y autoconf
cd htslib-1.21/
autoreconf -i
./configure --prefix=$1 CPPFLAGS='-foverflow-shift-alt-behavior'
make -j
make install
