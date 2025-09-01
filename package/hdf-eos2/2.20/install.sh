#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z -f HDF-EOS2.20v1.00.tar
cd ${JARVIS_TMP}
# gzip -d ${JARVIS_DOWNLOAD}/HDF-EOS2.20v1.00.tar
tar -xvf ${JARVIS_DOWNLOAD}/HDF-EOS2.20v1.00.tar
cd hdfeos

ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure --with-hdf4=${HDF4_PATH} --with-jpeg=${LIBJPEG_PATH} --with-zlib=/usr/local --prefix=$1 --build=aarch64-unknown-linux-gnu
make -j
make install
cp -r include $1/
