#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/sylabs/singularity/tar.gz/refs/tags/v3.9.9 -f singularity-3.9.9.tar.gz
. ${DOWNLOAD_TOOL} -u https://dl.google.com/go/go1.18.1.linux-arm64.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/singularity-3.9.9.tar.gz
cd singularity-3.9.9
tar -xvf ${JARVIS_DOWNLOAD}/go1.18.1.linux-arm64.tar.gz
export PATH=${JARVIS_TMP}/singularity-3.9.9/go/bin:$PATH
mkdir build_clang
sed -i '14c\hstcc=clang' mconfig
sed -i '16c\hstcxx=clang++' mconfig
sed -i '26c\tgtcc=clang' mconfig
sed -i '28c\tgtcxx=clang++' mconfig
./mconfig -b ./build_clang -p ./bin
cd ./build_clang
cp config.h ../cmd/starter/
sed -i '111c\GOPROXY := https://goproxy.cn' Makefile
make
make install

