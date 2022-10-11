#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.9.0.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/v1.9.0.tar.gz
cd salmon-1.9.0
cmake -DNO_IPO=TRUE -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_C_FLAGS="-O3 -march=armv8.2-a -mtune=tsv110" -DCMAKE_CXX_FLAGS="-O3 -march=armv8.2-a -mtune=tsv110 -stdlib=libc++" -DCMAKE_EXE_LINKER_FLAGS="-stdlib=libc++ -lc++ -lc++abi" -DCMAKE_INSTALL_PREFIX=$1 .
make
mkdir -p $1/bin $1/lib
cp src/salmon $1/bin
cp -r external/install/* $1/lib
cp external/install/lib64/lib* $1/lib
