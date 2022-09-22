#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.openlb.net/wp-content/uploads/2020/11/olb-1.4r0.tgz -f olb-1.4r0.tgz
cd ${JARVIS_TMP}
rm -rf olb-1.4r0
tar -xvf ${JARVIS_DOWNLOAD}/olb-1.4r0.tgz
cd olb-1.4r0
make samples -j