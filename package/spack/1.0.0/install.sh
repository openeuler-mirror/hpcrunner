#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/spack/spack/archive/refs/tags/v1.0.0-alpha.4.tar.gz -f spack-1.0.0.tar.gz
cd ${JARVIS_ROOT}/tmp
if [ ! -d 'spack' ]; then
tar -xvf ${JARVIS_DOWNLOAD}/spack-1.0.0.tar.gz
mv spack-1.0.0-alpha.4 spack
fi
cd ${JARVIS_ROOT}
