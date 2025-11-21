#!/bin/bash

set -x
set -e

${DOWNLOAD_TOOL} -u https://files.pythonhosted.org/packages/af/0e/e81dfe4b4fb24023207d86e4d4ff418b0e83927f2155ed3552b0e3196846/Amara-1.2.0.2.tar.gz

${DOWNLOAD_TOOL} -u https://files.pythonhosted.org/packages/0e/ae/3c5b4fffb12be7c3a80c99475853349e1cf8477f99051921ea06fbf5e3b9/4Suite-XML-1.0.2.tar.gz

cd ${JARVIS_DEV}

if [ -d "4Suite-XML-1.0.2" ]; then
rm -rf 4Suite-XML-1.0.2
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/4Suite-XML-1.0.2.tar.gz

cd 4Suite-XML-1.0.2
python setup.py install
cd ..

if [ -d "Amara-1.2.0.2" ]; then
rm -rf Amara-1.2.0.2
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/Amara-1.2.0.2.tar.gz

cd Amara-1.2.0.2
python setup.py install