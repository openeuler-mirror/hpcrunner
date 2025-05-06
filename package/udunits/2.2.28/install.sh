#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://downloads.unidata.ucar.edu/udunits/2.2.28/udunits-2.2.28.tar.gz
cd ${JARVIS_TMP}
rm -rf udunits-2.2.28
tar xvf ${JARVIS_DOWNLOAD}/udunits-2.2.28.tar.gz
cd udunits-2.2.28
yum install -y expat-devel
./configure --prefix=$1
make -j
make install
