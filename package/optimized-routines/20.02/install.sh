#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/ARM-software/optimized-routines/tar.gz/v20.02 -f optimized-routines-20.02.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/optimized-routines-20.02.tar.gz
cd optimized-routines-20.02
cp config.mk.dist config.mk
make -j16
cp -r ./build/* $1

