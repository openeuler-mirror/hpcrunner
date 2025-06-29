#!/bin/bash
set -x
set -e
root_version=6.18.04
. ${DOWNLOAD_TOOL} -u https://root.cern/download/root_v${root_version}.source.tar.gz -f root_v${root_version}.tar.gz
. ${DOWNLOAD_TOOL} -u ${JARVIS_PROXY}/cern-fts/davix/archive/refs/tags/R_0_6_7.tar.gz -f davix-embedded-0.6.7.tar.gz

yum install -y python3-devel libX11-devel libXpm-devel libXft-devel libXext-devel
cd ${JARVIS_TMP}
rm -rf root_v${root_version}
tar -zxvf ${JARVIS_DOWNLOAD}/root_v${root_version}.tar.gz -C .
cd root-${root_version}/
rm -rf root_build
mkdir root_build
cd root_build/
CC=mpicc CXX=mpicxx cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC"

cp -ar ${JARVIS_DOWNLOAD}/davix-embedded-0.6.7.tar.gz builtins/davix/DAVIX-prefix/src/
sed -i 's/1694152a20a5c5e692c4bc545b2efbacec5274fb799e60725412ebae40cced3d/da1f65a86a4ebc3fb825b70a2b1147b72757003ca0ddfce4169d7fff4863de6f/' ../builtins/davix/CMakeLists.txt
sed -i 's/CMAKE_BUILD_TYPE:STRING=RelWithDebInfo/CMAKE_BUILD_TYPE:STRING=Release/' CMakeCache.txt
sed -i 's/clad:BOOL=ON/clad:BOOL=OFF/' CMakeCache.txt

make -j8
make install

exit 0
