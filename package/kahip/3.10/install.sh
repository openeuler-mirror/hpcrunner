#!/bin/bash
set -x
set -e
file_noext='KaHIP-3.10'
. ${DOWNLOAD_TOOL} -u https://github.com/KaHIP/KaHIP/archive/v3.10.tar.gz -f $file_noext.tar.gz
cd ${JARVIS_TMP}
rm -rf $file_noext
tar -xvf ${JARVIS_DOWNLOAD}/$file_noext.tar.gz
cd $file_noext
./compile_withcmake.sh
mkdir -p $1/lib
cp -rf deploy/* $1/lib/