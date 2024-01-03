#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz
cd ${JARVIS_TMP}
rm -rf bedtools2
tar -zxvf ${JARVIS_DOWNLOAD}/bedtools-2.28.0.tar.gz
cd bedtools2
sed -i '23c export CXX              = clang++' Makefile
sed -i '25c CC     = clang' src/utils/htslib/Makefile
make -j4
cp -a bin/ $1
