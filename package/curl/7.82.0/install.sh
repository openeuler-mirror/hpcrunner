#!/bin/bash
#https://github.com/curl/curl/releases/download/curl-7_82_0/curl-7.82.0.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
rm -rf curl-7.82.0
tar -xvf ${JARVIS_DOWNLOAD}/curl-7.82.0.tar.gz
cd curl-7.82.0
./buildconf
./configure --prefix=$1 --without-ssl
make
make install




