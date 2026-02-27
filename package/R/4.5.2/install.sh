#!/bin/bash
. $CHECK_ROOT && yum install -y libXt-devel readline-devel texinfo texlive texlive-inconsolata
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://cloud.r-project.org/src/base/R-4/R-4.5.2.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/R-4.5.2.tar.gz
cd R-4.5.2
./configure --prefix=$1 -enable-R-shlib --with-libpng --with-jpeglib --with-blas --with-lapack
make all -j
make install

