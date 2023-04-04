#!/bin/bash
set -x
set -e
lib_name='kml_adapter-master'
#. ${DOWNLOAD_TOOL} -u https://gitee.com/openeuler/kml_adapter.git -t git
cd $JARVIS_DOWNLOAD
cd ./$lib_name/kml_fft_adapter
sed -i "s/\/usr\/local\/kml/\$ENV{KML_GCC_PATH}/g" CMakeLists.txt
export C_INCLUDE_PATH=$KML_GCC_PATH/include/
export CPLUS_INCLUDE_PATH=$KML_GCC_PATH/include/
chmod +x build.sh
dos2unix build.sh
rm -rf build
./build.sh
mkdir -p $1/lib
cp -rf build/* $1/lib
cp -rf include $1/