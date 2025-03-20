#!/bin/bash
set -x
set -e
yum install -y libgeotiff-devel
. ${DOWNLOAD_TOOL} -u https://github.com/PDAL/PDAL/archive/refs/tags/2.3.0.tar.gz
cd ${JARVIS_TMP}
rm -rf PDAL-2.3.0
tar -xvf ${JARVIS_DOWNLOAD}/2.3.0.tar.gz
cd PDAL-2.3.0

# pdal依赖gdal，config文件中可通过module load gdal，直接在命令行安装pdal则需要执行导入：
# export GDAL_DIR=${JARVIS_LIBS}/bisheng4.1.0/gdal/3.4.1

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 ..
make -j4
make install
