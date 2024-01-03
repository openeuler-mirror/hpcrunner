#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/jellyfish-2.3.0.tar.gz
cd jellyfish-2.3.0
./configure --prefix=$1
make -j
make install