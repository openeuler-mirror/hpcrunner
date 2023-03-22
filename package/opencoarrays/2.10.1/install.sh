#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenCoarrays-2.10.1
tar -xvf ${JARVIS_DOWNLOAD}/OpenCoarrays-2.10.1.tar.gz
cd OpenCoarrays-2.10.1
mkdir -p opencoarrays-build && cd opencoarrays-build
cmake ${JARVIS_TMP}/OpenCoarrays-2.10.1/ -DCMAKE_INSTALL_PREFIX=$1
make -j7 && make install