#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
#rm -rf fftw-3.3.10

tar -xvf ${JARVIS_DOWNLOAD}/NeZha_Math_BLAS.tar.gz
mkdir -p $1/lib
cp ./920FSVE/release/kplblas/lib/* $1/lib
