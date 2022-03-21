#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
./configure CC=gcc CXX=g++ FC=gfortran --prefix=$1 --enable-pretty-print-stacktrace --enable-orterun-prefix-by-default  --with-knem=/opt/knem-1.1.4.90mlnx1/ --with-hcoll=/opt/mellanox/hcoll/ --with-cma --with-ucx --enable-mpi1-compatibility
make -j install
