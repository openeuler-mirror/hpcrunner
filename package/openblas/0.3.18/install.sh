#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.18.tar.gz
cd OpenBLAS-0.3.18
make -j
make PREFIX=$1 install
