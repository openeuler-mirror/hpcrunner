#!/bin/bash

set -x
set -e

jasper_ver="jasper-1.900.2"
clang_version=$($(which clang) -v 2>&1 | grep -oP 'clang version \K\d+\.\d+\.\d+')
mpicc_version=$($(which mpicc) -v 2>&1 | grep -oP 'clang version \K\d+\.\d+\.\d+')

. ${DOWNLOAD_TOOL} -u https://www.ece.uvic.ca/~frodo/jasper/software/${jasper_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf ${jasper_ver}
tar -xvf ${JARVIS_DOWNLOAD}/${jasper_ver}.tar.gz
cd ${jasper_ver}
./configure --prefix=$1

if [[ ${clang_version} == 17.* ]] || [[ ${mpicc_version} == 17.* ]]; then
  sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/base/jas_getopt.c
  sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/bmp/bmp_dec.c
  sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/jpc/jpc_t1dec.c
  sed -i '71a #include "jasper/jas_debug.h"' ./src/libjasper/jpg/jpg_dummy.c
  sed -i '71a #include "jasper/jas_debug.h"' ./src/libjasper/mif/mif_cod.c
  sed -i '81a #include "jasper/jas_debug.h"' ./src/libjasper/pnm/pnm_dec.c

  sed -i 's/jpc_ft_synthesize(int/jpc_ft_synthesize(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.c
  sed -i 's/analyze)(int/analyze)(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.h
  sed -i 's/synthesize)(int/synthesize)(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.h
  sed -i '76a #include "jpc_fix.h"' ./src/libjasper/jpc/jpc_qmfb.h

  sed -i -e '122,129H' -e '122,129d' -e '148G' ./src/libjasper/jpc/jpc_tsfb.c
  sed -i -e '150,157H' -e '150,157d' -e '177G' ./src/libjasper/jpc/jpc_tsfb.c
fi

make -j
make install
