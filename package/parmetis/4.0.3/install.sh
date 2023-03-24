#!/bin/bash
set -x
set -e
. $CHECK_ROOT && yum install libstdc++-devel.aarch64 bison flex cmake -y
. ${DOWNLOAD_TOOL} -u http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz
cd ${JARVIS_TMP}
rm -rf parmetis-4.0.3
tar -xvf ${JARVIS_DOWNLOAD}/parmetis-4.0.3.tar.gz
cd parmetis-4.0.3
sed -i -e 's/\#define IDXTYPEWIDTH 32/\#define IDXTYPEWIDTH 64/g' metis/include/metis.h
cd metis
make config shared=1 prefix=$1
make install
cd ../
sed -i -e '29i add_compile_options(-fPIC)' CMakeLists.txt
make config shared=1 prefix=$1
make install