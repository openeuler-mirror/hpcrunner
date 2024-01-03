#!/bin/bash
set -x

. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/nerscadmin/IPM/archive/refs/tags/2.0.6.tar.gz -f IPM-2.0.6.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/IPM-2.0.6.tar.gz
cd IPM-2.0.6
./bootstrap.sh
./bootstrap.sh
sed -i "5749cint main(int argc, char *argv[]) {" configure
./configure --prefix=$1
make 
make install
