#!/bin/bash
#$JARVIS_PROXY/curl/curl/releases/download/curl-7_82_0/curl-7.82.0.tar.gz
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/curl/curl/releases/download/curl-7_82_0/curl-7.82.0.tar.gz
cd ${JARVIS_TMP}
rm -rf curl-7.82.0
tar -xvf ${JARVIS_DOWNLOAD}/curl-7.82.0.tar.gz
cd curl-7.82.0
./buildconf
./configure --prefix=$1 --without-ssl
make
make install




