#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
cd scalapack-2.1.0
cp SLmake.inc.example SLmake.inc
make -j
mkdir $1/lib
cp *.a $1/lib
