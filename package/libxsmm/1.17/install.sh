#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
libxsmm_ver=aarch64-v1.0
. ${DOWNLOAD_TOOL} -u https://github.com/MiyaaL/libxsmm/archive/refs/tags/${libxsmm_ver}.tar.gz -f libxsmm-${libxsmm_ver}.tar.gz
rm -rf libxsmm-${libxsmm_ver}
tar -xvzf ${JARVIS_DOWNLOAD}/libxsmm-${libxsmm_ver}.tar.gz
cd libxsmm-${libxsmm_ver}
cd $1
make -j -f ${JARVIS_TMP}/libxsmm-${libxsmm_ver}/Makefile STATIC=0 JIT=1 LIBXSMM_JIT=1 LIBXSMM_CONFIG_JIT=1 INTRINSICS=2301

