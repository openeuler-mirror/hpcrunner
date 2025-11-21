#!/bin/bash
set -e
set -x
install_path=$1

${DOWNLOAD_TOOL} -u https://codeload.github.com/ampl/gsl/tar.gz/v2.5.0 -f gsl-2.5.0.tar.gz

cd ${JARVIS_TMP}

if [ ! -d "gsl-2.5.0" ]; then
    tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/gsl-2.5.0.tar.gz
fi
cd gsl-2.5.0

if [ -d "build" ]; then
    rm -rf build
fi
mkdir build
cd build
../configure --prefix=$install_path \
    --enable-shared --enable-static CC=clang

make -j
make install
