#!/bin/bash
set -x
set -e

yum install -y proj-devel
. ${DOWNLOAD_TOOL} -u https://download.osgeo.org/gdal/3.4.1/gdal-3.4.1.tar.gz
cd ${JARVIS_TMP}
rm -rf gdal-3.4.1
tar -zxf ${JARVIS_DOWNLOAD}/gdal-3.4.1.tar.gz
cd gdal-3.4.1

if [ -z "$HDF5_CLANG_PATH" ]; then
    ./configure --prefix=$1 --with-hdf5=no
else
    # HDF5版本不可超过1.13.x, 高版本H5FD_class_t结构体发生变化，gdal3.4.1中定义的变量无法匹配
    ./configure --prefix=$1 --with-hdf5=${HDF5_CLANG_PATH}
fi

make -j
make install

