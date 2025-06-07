#!/bin/bash

set -e
export PATH=${JARVIS_ROOT}/software/apps/fpchecker/bin:$PATH
export LD_LIBRARY_PATH=${JARVIS_ROOT}/software/apps/fpchecker/lib64:$LD_LIBRARY_PATH

cd ${JARVIS_TMP_DOWNLOAD}/curl-7.82.0/
CC=mpicc-fpchecker CXX=mpicxx-fpchecker ./configure --prefix=${JARVIS_ROOT}/software/apps/curl --without-ssl
FPC_INSTRUMENT=1 make -j
FPC_INSTRUMENT=1 make install

${JARVIS_ROOT}/software/apps/curl/bin/curl www.baidu.com
