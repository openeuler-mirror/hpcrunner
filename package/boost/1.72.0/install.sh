#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh
./b2 install --prefix=$1