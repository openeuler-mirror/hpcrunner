#!/bin/bash
set -x
set -e

${DOWNLOAD_TOOL} -u https://gitlab.com/libxc/libxc/-/archive/6.2.2/libxc-6.2.2.tar.gz

PATH_INSTALL=$1
BASENAME=$(basename "$1")
WORK_DIR=${JARVIS_DEV_VROOT}/ga/${BASENAME}
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}

if [ -d "libxc-6.2.2" ]; then
rm -rf libxc-6.2.2
fi

tar -xvf ${JARVIS_DOWNLOAD}/libxc-6.2.2.tar.gz
cd libxc-6.2.2

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PATH_INSTALL -DCMAKE_BUILD_TYPE=Release \
         -DBUILD_SHARED_LIBS=ON -DENABLE_FORTRAN=ON -DENABLE_PYTHON=ON \
         -DDISABLE_FXC=ON -DDISABLE_KXC=ON -DDISABLE_LXC=ON -DBUILD_TESTING=OFF
make -j16
make install
