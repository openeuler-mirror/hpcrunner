#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz
cd ${JARVIS_TMP}
rm -rf mysql++-3.3.0
tar -xvf ${JARVIS_DOWNLOAD}/mysql++-3.3.0.tar.gz
cd mysql++-3.3.0
./configure --prefix=$1
make -j && make install
