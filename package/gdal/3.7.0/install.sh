#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://download.osgeo.org/gdal/3.7.0/gdal-3.7.0.tar.xz
cd ${JARVIS_TMP}
rm -rf gdal-2.2.4
tar -xvf ${JARVIS_DOWNLOAD}/gdal-3.7.0.tar.xz > /dev/null 2>&1
cd gdal-3.7.0/
mkdir build
cd build
cmake ../ 
make install