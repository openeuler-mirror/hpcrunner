#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/ElmerCSC/elmerfem/archive/refs/tags/scc20.tar.gz
cd ${JARVIS_DOWNLOAD}
mv scc20.tar.gz elmerfem-scc20.tar.gz
cd ${JARVIS_TMP}
rm -rf elmerfem-scc20
tar -xvf ${JARVIS_DOWNLOAD}/elmerfem-scc20.tar.gz