#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
. ${DOWNLOAD_TOOL} -u https://www.cp2k.org/static/downloads/libxc-5.1.4.tar.gz -f libxc-5.1.4.tar.gz
rm -rf libxc-5.1.4
tar -xvf ${JARVIS_DOWNLOAD}/libxc-5.1.4.tar.gz
cd libxc-5.1.4
sed -i 21305s/lt_lt_prog_compiler_wl/lt_prog_compiler_wl/g configure
sed -i 21547s/lt_lt_prog_compiler_wl_FC/lt_prog_compiler_wl_FC/g configure
./configure --prefix=$1 CFLAGS='-fPIC' FCFLAGS='-fPIC' --enable-shared=yes --enable-static=yes
sed -i "705c lt_prog_compiler_wl_FC=\'-Wl,\'" config.status
make -j
make install

