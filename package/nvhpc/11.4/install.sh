#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://developer.download.nvidia.com/hpc-sdk/21.9/nvhpc_2021_219_Linux_aarch64_cuda_11.4.tar.gz
cd ${JARVIS_TMP}
#rm -rf nvhpc_2021_219_Linux_aarch64_cuda_11.4
tar zxvf ${JARVIS_DOWNLOAD}/nvhpc_2021_219_Linux_aarch64_cuda_11.4.tar.gz
cd nvhpc_2021_219_Linux_aarch64_cuda_11.4
./install
