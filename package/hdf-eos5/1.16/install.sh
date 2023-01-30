#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos5/7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS5.1.16.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS5.1.16.tar.Z
cd ${JARVIS_DOWNLOAD}
cp -f 7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452* HDF-EOS5.1.16.tar
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/HDF-EOS5.1.16.tar
cd hdfeos5

./configure CC=${HDF5_PATH}/bin/h5pcc --with-hdf4=${HDF5_PATH} --with-zlib=/usr/local --prefix=$1 
make -j
make install
cp -r include $1/