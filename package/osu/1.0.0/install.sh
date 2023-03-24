#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/forresti/osu-micro-benchmarks/archive/refs/heads/master.zip -f osu-micro-benchmarks.zip
cd ${JARVIS_TMP}
unzip ${JARVIS_DOWNLOAD}/osu-micro-benchmarks.zip
cd osu-micro-benchmarks-master
./configure --prefix=$1 CC=mpicc CXX=mpicxx
make
make install
