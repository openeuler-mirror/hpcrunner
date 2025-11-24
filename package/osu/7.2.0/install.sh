#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.2.tar.gz -f osu-micro-benchmarks-7.2.tar.gz
cd ${JARVIS_TMP}
rm -rf osu-micro-benchmarks-7.2
tar -xzvf ${JARVIS_DOWNLOAD}/osu-micro-benchmarks-7.2.tar.gz
cd osu-micro-benchmarks-7.2
./configure --prefix=$1 CC=mpicc CXX=mpicxx
make -j32
make install
