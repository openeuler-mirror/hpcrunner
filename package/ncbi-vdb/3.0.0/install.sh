#!/bin/bash
set -x
set -e

wget https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.0.tar.gz -O ${JARVIS_DOWNLOAD}/ncbi-vdb-3.0.0.tar.gz
yum -y install doxygen cmake
yum install wget git tar libatomic git openssl glibc-devel libstdc++-static make perl cmake fuse-devel libxml2-devel file-devel patch -y

cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/ncbi-vdb-3.0.0.tar.gz

cd ncbi-vdb-3.0.0
cp -r interfaces/cc/gcc/arm64 interfaces/cc/gcc/aarch64
./configure --relative-build-out-dir
make -j  && make install