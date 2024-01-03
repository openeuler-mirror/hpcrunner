#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/mfem/mfem/archive/refs/tags/v4.4.tar.gz
cd ${JARVIS_TMP}
rm -rf mfem-4.4
tar -xvf ${JARVIS_DOWNLOAD}/v4.4.tar.gz
sed -i 's/>= MINSIGSTKSZ.*/;/' mfem-4.4/tests/unit/catch.hpp
cd mfem-4.4
make parallel
make install PREFIX=$1