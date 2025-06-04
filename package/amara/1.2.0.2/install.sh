#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.huaweicloud.com/repository/pypi/packages/af/0e/e81dfe4b4fb24023207d86e4d4ff418b0e83927f2155ed3552b0e3196846/Amara-1.2.0.2.tar.gz#sha256=0814dae65bfeb3b309d65d7efb01e2e7a8c30611e7232f839c390816edac27cb -f Amara-1.2.0.2.tar.gz
. ${DOWNLOAD_TOOL} -u https://pypi.tuna.tsinghua.edu.cn/packages/0e/ae/3c5b4fffb12be7c3a80c99475853349e1cf8477f99051921ea06fbf5e3b9/4Suite-XML-1.0.2.tar.gz#sha256=f0c24132eb2567e64b33568abff29a780a2f0236154074d0b8f5262ce89d8c03 -f 4Suite-XML-1.0.2.tar.gz
cd ${JARVIS_TMP}
rm -rf Amara-1.2.0.2 4Suite-XML-1.0.2
tar -xvzf ${JARVIS_DOWNLOAD}/Amara-1.2.0.2.tar.gz
tar -xvzf ${JARVIS_DOWNLOAD}/4Suite-XML-1.0.2.tar.gz

cd 4Suite-XML-1.0.2
python setup.py install
cd ..

cd Amara-1.2.0.2
python setup.py install
