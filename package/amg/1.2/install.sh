#!/bin/bash
set -x
set -e
amg_ver='1.2'
. ${DOWNLOAD_TOOL} -u https://github.com/LLNL/AMG/archive/refs/tags/${amg_ver}.zip
cd ${JARVIS_ROOT}
rm -rf AMG-${amg_ver}
unzip ${JARVIS_DOWNLOAD}/${amg_ver}.zip
cd AMG-${amg_ver} 
sed -i "46c INCLUDE_CFLAGS = -O2 -Wno-implicit-function-declaration -Wno-implicit-int -DTIMER_USE_MPI -DHYPRE_USING_OPENMP -fopenmp -DHYPRE_HOPSCOTCH -DHYPRE_USING_PERSISTENT_COMM -DHYPRE_BIGINT -mcpu=linxicore9100  -mllvm -force-customized-pipeline=true" Makefile.include
make -j
mkdir $1/bin -p
cp ./test/* $1/bin
