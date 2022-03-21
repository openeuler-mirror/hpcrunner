#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/Hyper-MPI_1.1.0_aarch64_CentOS7.6_GCC9.3_MLNX-OFED4.9.tar.gz -C $1 --strip-components=1