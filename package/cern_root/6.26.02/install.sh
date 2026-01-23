#!/bin/bash
set -x
set -e
root_version=6.26.02
. ${DOWNLOAD_TOOL} -u https://root.cern/download/root_v${root_version}.source.tar.gz -f root_v${root_version}.tar.gz
#. ${DOWNLOAD_TOOL} -u ${JARVIS_PROXY}/cern-fts/davix/archive/refs/tags/R_0_6_7.tar.gz -f davix-embedded-0.6.7.tar.gz

yum install -y python3-devel libX11-devel libXpm-devel libXft-devel libXext-devel cmake
cd ${JARVIS_TMP}
rm -rf root_v${root_version}
tar -zxvf ${JARVIS_DOWNLOAD}/root_v${root_version}.tar.gz -C .
cd root-${root_version}/
rm -rf root_build
mkdir root_build
cd root_build/
#CC=mpicc CXX=mpicxx cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC"
export CC=mpicc CXX=mpicxx
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$1 -Dclad=OFF -Dxrootd=OFF -DCMAKE_CXX_FLAGS=" -Wno-enum-constexpr-conversion"

sed -i "5c #include <cstring>" ../tmva/sofie/src/RModel.cxx
sed -i "3c #include <cstring>" ../tmva/sofie/inc/TMVA/SOFIE_common.hxx

make -j8
make install

exit 0
