#!/bin/bash
set -x
set -e

if [[ $UseGitee -eq 1 ]]; then
#. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/OpenBLAS/archive/refs/tags/v${openblas_ver}.tar.gz -f OpenBLAS-${openblas_ver}.tar.gz
cd ${JARVIS_TMP}
git clone https://gitee.com/kp-hpc-mod/OpenBLAS.git
mv OpenBLAS OpenBLAS-${openblas_ver}
cd OpenBLAS-${openblas_ver}
git checkout v${openblas_ver}
else
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/OpenMathLib/OpenBLAS/releases/download/v${openblas_ver}/OpenBLAS-v${openblas_ver}.tar.gz -f OpenBLAS-${openblas_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenBLAS-${openblas_ver}
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-${openblas_ver}.tar.gz
cd OpenBLAS-${openblas_ver}
fi


make -j
make PREFIX=$1 install