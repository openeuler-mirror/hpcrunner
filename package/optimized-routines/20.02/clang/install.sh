#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/ARM-software/optimized-routines/tar.gz/v20.02 -f optimized-routines-20.02.tar.gz
cd ${JARVIS_TMP}
tar -zxvf ${JARVIS_DOWNLOAD}/optimized-routines-20.02.tar.gz
cd optimized-routines-20.02
sed -i "13c\CC = clang" config.mk.dist
sed -i "19c\HOST_CC = clang" config.mk.dist
sed -i "14c\HOST_CC = clang" Makefile
cp config.mk.dist config.mk
make -j16
cp -r ./build/* $1

