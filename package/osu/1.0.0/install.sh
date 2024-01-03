#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/forresti/osu-micro-benchmarks/archive/refs/heads/master.zip -f osu-micro-benchmarks.zip
cd ${JARVIS_TMP}
rm -rf osu-micro-benchmarks-master
unzip ${JARVIS_DOWNLOAD}/osu-micro-benchmarks.zip
cd osu-micro-benchmarks-master
./configure --prefix=$1 CC=mpicc CXX=mpicxx
make -j32
make install
