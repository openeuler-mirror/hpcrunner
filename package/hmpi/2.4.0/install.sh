#!/bin/bash
set -x
set -e
hmpi_version='2.4.0'
. ${DOWNLOAD_TOOL} -u https://gitee.com/kunpengcompute/hucx/repository/archive/v2.4.0-huawei.tar.gz -f hucx-${hmpi_version}-huawei.tar.gz
. ${DOWNLOAD_TOOL} -u https://gitee.com/kunpengcompute/xucg/repository/archive/v2.4.0-huawei.tar.gz -f xucg-${hmpi_version}-huawei.tar.gz
. ${DOWNLOAD_TOOL} -u https://gitee.com/kunpengcompute/hmpi/repository/archive/v2.4.0-huawei.tar.gz -f hmpi-${hmpi_version}-huawei.tar.gz
cd ${JARVIS_TMP}
. $CHECK_ROOT && yum install -y perl-Data-Dumper autoconf automake libtool binutils flex
rm hucx-v${hmpi_version}-huawei -rf
tar xf ${JARVIS_DOWNLOAD}/hucx-${hmpi_version}-huawei.tar.gz
cd hucx-v${hmpi_version}-huawei
./autogen.sh
./contrib/configure-opt --prefix=$1/hucx --disable-numa --enable-mt CFLAGS="-Wno-unused-but-set-variable -Wno-error=int-conversion" CXXFLAGS="-Wno-unused-but-set-variable -Wno-error=int-conversion"
make -j
make -j install
cd -
export LD_LIBRARY_PATH=$1/hucx/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$1/hucx/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$1/hucx/include:$CPLUS_INCLUDE_PATH

export CFLAGS="-Wno-unused-but-set-variable -Wno-error=int-conversion" CXXFLAGS="-Wno-unused-but-set-variable -Wno-error=int-conversion" FFLAGS="-Wno-error=int-conversion"

rm xucg-v${hmpi_version}-huawei/ -rf
tar xf ${JARVIS_DOWNLOAD}/xucg-${hmpi_version}-huawei.tar.gz
cd xucg-v${hmpi_version}-huawei/
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1/xucg -DCMAKE_BUILD_TYPE=Release -DUCG_BUILD_WITH_UCX=$1/hucx -DUCG_ENABLE_MT=ON -DUCG_BUILD_TESTS=OFF -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_Fortran_COMPILER=$FC
make -j
make -j install
cd -
export LD_LIBRARY_PATH=$1/xucg/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$1/xucg/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$1/xucg/include:$CPLUS_INCLUDE_PATH

rm hmpi-v${hmpi_version}-huawei/ -rf
tar xf ${JARVIS_DOWNLOAD}/hmpi-${hmpi_version}-huawei.tar.gz
cd hmpi-v${hmpi_version}-huawei/
./autogen.pl
./configure --prefix=$1 --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$1/hucx --with-ucg=$1/xucg
make -j
make -j install
cd -

