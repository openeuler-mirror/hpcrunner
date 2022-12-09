#!/bin/bash
set -x
set -e
lib_name='kml_adapter'
. ${DOWNLOAD_TOOL} -u https://gitee.com/openeuler/kml_adapter.git -t git
cd $JARVIS_DOWNLOAD
cd ./$lib_name/kml_fft_adapter
export C_INCLUDE_PATH=/usr/local/kml/include/
export CPLUS_INCLUDE_PATH=/usr/local/kml/include/
chmod +x build.sh
dos2unix build.sh
rm -rf build
./build.sh
mkdir -p $1/lib
cp -rf build/* $1/lib