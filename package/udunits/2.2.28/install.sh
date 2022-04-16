#!/bin/bash
#下载地址：https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/udunits-2.2.28.tar.gz
cd udunits-2.2.28
./configure --prefix=$1
make -j
make install
