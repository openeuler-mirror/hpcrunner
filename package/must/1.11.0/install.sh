#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://hpc.rwth-aachen.de/must/files/MUST-v1.11.0.tar.gz
cd ${JARVIS_TMP}
rm -rf MUST-v1.11.0
tar -xvf ${JARVIS_DOWNLOAD}/MUST-v1.11.0.tar.gz

#yum install elfutils-devel binutils-devel libdwarf-devel -y
cd MUST-v1.11.0
sed -i "1046s/va_alist/\&va_alist/g" ./externals/GTI/externals/PnMPI/src/pnmpi/wrapper.c
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DCMAKE_BUILD_TYPE=Release
make install -j
