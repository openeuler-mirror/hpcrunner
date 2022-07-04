#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u https://www.cp2k.org/static/downloads/lapack-3.8.0.tgz
cd ${JARVIS_TMP}
rm -rf lapack-3.8.0
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.8.0.tgz
cd lapack-3.8.0
cp make.inc.example make.inc
make -j
mkdir $1/lib/
cp *.a $1/lib/
