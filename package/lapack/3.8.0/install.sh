#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.8.0.tgz
cd lapack-3.8.0
cp make.inc.example make.inc
make -j
mkdir $1/lib/
cp *.a $1/lib/