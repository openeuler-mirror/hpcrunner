#!/bin/bash
. $CHECK_ROOT && yum install libXt-devel.aarch64 readline-devel.aarch64
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://cloud.r-project.org/src/base/R-3/R-3.6.3.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/R-3.6.3.tar.gz
cd R-3.6.3
./configure -enable-R-shlib -enable-R-static-lib --with-libpng --with-jpeglib --prefix=$1
make all -j
make install
