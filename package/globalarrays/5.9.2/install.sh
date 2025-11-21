#!/bin/bash
set -x
set -e

${DOWNLOAD_TOOL} -u https://github.com/GlobalArrays/ga/releases/download/v5.9.2/ga-5.9.2.tar.gz

PATH_INSTALL=$1
BASENAME=$(basename "$1")
WORK_DIR=${JARVIS_DEV_VROOT}/ga/${BASENAME}
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}

if [ -d "ga-5.9.2" ]; then
rm -rf ga-5.9.2
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/ga-5.9.2.tar.gz
cd ga-5.9.2

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

./configure --prefix=$PATH_INSTALL \
    CFLAGS="-fsigned-char" CXXFLAGS="-fsigned-char"

make
make check
make install
