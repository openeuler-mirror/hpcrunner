#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz
cd ${JARVIS_TMP}
rm -rf udunits-2.2.28
tar xvf ${JARVIS_DOWNLOAD}/udunits-2.2.28.tar.gz
cd udunits-2.2.28
./configure --prefix=$1
make -j
make install
