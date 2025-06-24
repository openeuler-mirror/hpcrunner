#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.huaweicloud.com/repository/pypi/packages/af/0e/e81dfe4b4fb24023207d86e4d4ff418b0e83927f2155ed3552b0e3196846/Amara-1.2.0.2.tar.gz#sha256=0814dae65bfeb3b309d65d7efb01e2e7a8c30611e7232f839c390816edac27cb -f Amara-1.2.0.2.tar.gz
cd ${JARVIS_TMP}
rm -rf Amara-1.2.0.2
tar -xvzf ${JARVIS_DOWNLOAD}/Amara-1.2.0.2.tar.gz

cd Amara-1.2.0.2
python setup.py install
