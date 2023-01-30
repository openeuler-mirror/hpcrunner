#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.antlr2.org/download/antlr-2.7.7.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/antlr-2.7.7.tar.gz
cd antlr-2.7.7
sed -i "13a #include <strings.h>" lib/cpp/antlr/CharScanner.hpp
sed -i "14a #include <cstdio>" lib/cpp/antlr/CharScanner.hpp
./configure \
--prefix=$1 \
--disable-csharp \
--disable-java \
--disable-python
make -j
make install
