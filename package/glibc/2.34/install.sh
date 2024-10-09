#!/bin/bash
set -x
set -e
glibc_ver='2.34'
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/gnu/glibc/glibc-${glibc_ver}.tar.xz
cd ${JARVIS_TMP}
rm -rf glibc-${glibc_ver}
tar -zxvf ${JARVIS_DOWNLOAD}/glibc-${glibc_ver}.tar.xz
cd glibc-${glibc_ver}
mkdir build
cd build
unset LD_LIBRARY_PATH
../configure --prefix=$1 --disable-profile --enable-add-ons --with-headers=/usr/include --disable-sanity-checks --disable-werror
make -j
make install