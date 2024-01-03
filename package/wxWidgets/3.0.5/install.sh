#download from $JARVIS_PROXY/wxWidgets/wxWidgets/archive/refs/tags/v3.0.5.tar.gz
#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/wxWidgets/wxWidgets/archive/refs/tags/v3.0.5.tar.gz -f wxWidgets-3.0.5.tar.gz
cd ${JARVIS_TMP}
rm -rf wxWidgets-3.0.5
tar -xvf ${JARVIS_DOWNLOAD}/wxWidgets-3.0.5.tar.gz
cd wxWidgets-3.0.5
#CC=clang CXX=clang++ FC=flang
./configure --disable-gui  --prefix=$1  
make -j
make install
