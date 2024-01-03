#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/hucx/archive/refs/tags/v1.1.1-huawei.zip -f hucx-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/xucg/archive/refs/tags/v1.1.1-huawei.zip -f xucg-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip -f hmpi-1.1.1-huawei.zip
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum install -y perl-Data-Dumper autoconf automake libtool binutils flex
rm -rf hmpi-1.1.1-huawei hucx-1.1.1-huawei xucg-1.1.1-huawei
unzip ${JARVIS_DOWNLOAD}/hucx-1.1.1-huawei.zip
unzip ${JARVIS_DOWNLOAD}/xucg-1.1.1-huawei.zip
unzip ${JARVIS_DOWNLOAD}/hmpi-1.1.1-huawei.zip
\cp -rf xucg-1.1.1-huawei/* hucx-1.1.1-huawei/src/ucg/
sleep 3
cd hucx-1.1.1-huawei
./autogen.sh
./contrib/configure-opt --prefix=$1/hucx CFLAGS="-DHAVE___CLEAR_CACHE=1" --disable-numa --without-java
for file in `find . -name Makefile`;do sed -i "s/-Werror//g" $file;done
for file in `find . -name Makefile`;do sed -i "s/-implicit-function-declaration//g" $file;done
make -j64
make install
cd ../hmpi-1.1.1-huawei
./autogen.pl
./configure --prefix=$1 --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$1/hucx
make -j64
make install
