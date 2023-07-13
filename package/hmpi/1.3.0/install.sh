#!/bin/bash
set -x
set -e
hmpi_version='1.3.0'
#. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/hucx/archive/refs/tags/v${hmpi_version}-huawei.zip -f hucx-${hmpi_version}-huawei.zip
. ${DOWNLOAD_TOOL} -u https://github.com/openucx/ucx/archive/refs/tags/v1.10.1.tar.gz -f hucx-${hmpi_version}-huawei.tar.gz
#. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/xucg/archive/refs/tags/v${hmpi_version}-huawei.zip -f xucg-${hmpi_version}-huawei.zip
. ${DOWNLOAD_TOOL} -u https://gitee.com/kunpengcompute/xucg/archive/refs/tags/v1.3.0-huawei.tar.gz -f xucg-${hmpi_version}-huawei.tar.gz
#. ${DOWNLOAD_TOOL} -u https://github.com/kunpengcompute/hmpi/archive/refs/tags/v${hmpi_version}-huawei.zip -f hmpi-${hmpi_version}-huawei.zip
. ${DOWNLOAD_TOOL} -u https://gitee.com/kunpengcompute/hmpi/archive/refs/tags/v1.3.0-huawei.tar.gz -f hmpi-${hmpi_version}-huawei.tar.gz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum install -y perl-Data-Dumper autoconf automake libtool binutils flex
rm ucx-1.10.1 -rf
tar xf ${JARVIS_DOWNLOAD}/hucx-1.3.0-huawei.tar.gz
cd ucx-1.10.1
./autogen.sh
./contrib/configure-opt --prefix=$1/hucx --disable-numa --enable-mt CC=clang CXX=clang++ FC=flang CFLAGS="-Wno-unused-but-set-variable" CXXFLAGS="-Wno-unused-but-set-variable"
make -j128
make -j128 install
cd -
export LD_LIBRARY_PATH=$1/hucx/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$1/hucx/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$1/hucx/include:$CPLUS_INCLUDE_PATH

rm xucg-v1.3.0-huawei/ -rf
tar xf ${JARVIS_DOWNLOAD}/xucg-1.3.0-huawei.tar.gz
cd xucg-v1.3.0-huawei/
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1/xucg -DCMAKE_BUILD_TYPE=Release -DUCG_BUILD_WITH_UCX=$1/hucx -DUCG_ENABLE_MT=ON -DUCG_BUILD_TESTS=OFF -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_Fortran_COMPILER=flang
make -j128
make -j128 install
cd -
export LD_LIBRARY_PATH=$1/xucg/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$1/xucg/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$1/xucg/include:$CPLUS_INCLUDE_PATH

rm hmpi-v1.3.0-huawei/ -rf
tar xf ${JARVIS_DOWNLOAD}/hmpi-1.3.0-huawei.tar.gz
cd hmpi-v1.3.0-huawei/
./autogen.pl
./configure --prefix=$1 --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$1/hucx --with-ucg=$1/xucg CC=clang CXX=clang++ FC=flang
make -j128
make -j128 install
cd -

