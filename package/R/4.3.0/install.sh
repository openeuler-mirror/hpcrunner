#!/bin/bash
set -x
set -e

. $CHECK_ROOT 
yum install libXt-devel.aarch64 readline-devel.aarch64  -y
yum install libX11-devel libz bzip2-devel liblzma*  xz-devel pcre-devel pcre2-devel libcurl-devel -y

. ${DOWNLOAD_TOOL} -u https://cran.r-project.org/src/base/R-4/R-4.3.0.tar.gz

cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/R-4.3.0.tar.gz
cd R-4.3.0
./configure -enable-R-shlib -enable-R-static-lib --with-libpng --with-jpeglib --prefix=$1
make all -j
make install