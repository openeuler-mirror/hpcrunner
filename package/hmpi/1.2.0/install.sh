#!/bin/bash
set -x
set -e
hmpi_version='1.2.0'
. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/hucx/archive/refs/tags/v${hmpi_version}-huawei.zip -f hucx-${hmpi_version}-huawei.zip
. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/xucg/archive/refs/tags/v${hmpi_version}-huawei.zip -f xucg-${hmpi_version}-huawei.zip
. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/hmpi/archive/refs/tags/v${hmpi_version}-huawei.zip -f hmpi-${hmpi_version}-huawei.zip
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum install -y perl-Data-Dumper autoconf automake libtool binutils flex
rm -rf hmpi-${hmpi_version}-huawei hucx-${hmpi_version}-huawei xucg-${hmpi_version}-huawei
unzip ${JARVIS_DOWNLOAD}/hucx-${hmpi_version}-huawei.zip
unzip ${JARVIS_DOWNLOAD}/xucg-${hmpi_version}-huawei.zip
unzip ${JARVIS_DOWNLOAD}/hmpi-${hmpi_version}-huawei.zip
\cp -rf xucg-${hmpi_version}-huawei/* hucx-${hmpi_version}-huawei/src/ucg/
sleep 3
cd hucx-${hmpi_version}-huawei
./autogen.sh
./contrib/configure-opt --prefix=$1/hucx CFLAGS="-DHAVE___CLEAR_CACHE=1" --disable-numa --without-java
for file in `find . -name Makefile`;do sed -i "s/-Werror//g" $file;done
for file in `find . -name Makefile`;do sed -i "s/-implicit-function-declaration//g" $file;done
make -j64
make install
cd ../hmpi-${hmpi_version}-huawei
./autogen.pl
./configure --prefix=$1 --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$1/hucx
make -j64
make install

