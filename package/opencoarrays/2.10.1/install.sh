#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenCoarrays-2.10.1
tar -xvf ${JARVIS_DOWNLOAD}/OpenCoarrays-2.10.1.tar.gz
cd OpenCoarrays-2.10.1
rm -rf opencoarrays-build
mkdir opencoarrays-build && cd opencoarrays-build
cmake .. -DCMAKE_BUILD_TYPE:STRING="Release"
make -j
make install -j