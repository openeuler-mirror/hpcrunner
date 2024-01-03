#!/bin/bash

set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/GNOME/libxml2/archive/v2.10.1.tar.gz -f libxml2-2.10.1.tar.gz
cd ${JARVIS_TMP}
rm -rf libxml2-2.10.1
tar -xvf ${JARVIS_DOWNLOAD}/libxml2-2.10.1.tar.gz
cd libxml2-2.10.1
./autogen.sh
./configure --prefix=$1 CFLAGS='-O2 -fno-semantic-interposition' --with-python=no
make -j
make install