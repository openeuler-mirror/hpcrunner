#!/bin/bash

# download from https://codeload.github.com/ImageMagick/ImageMagick/tar.gz/refs/tags/7.1.0-30
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/ImageMagick/ImageMagick/tar.gz/refs/tags/7.1.0-30 -f ImageMagick-7.1.0-30.tar.gz

cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/ImageMagick-7.1.0-30.tar.gz
cd ImageMagick-7.1.0-30

./configure --prefix=$1 

make -j
make install

