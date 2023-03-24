#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
./configure CC=gcc CXX=g++ FC=gfortran --prefix=$1 --enable-pretty-print-stacktrace --enable-orterun-prefix-by-default --enable-mpi1-compatibility
make -j install
