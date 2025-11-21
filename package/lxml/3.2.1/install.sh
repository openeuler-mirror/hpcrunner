#!/bin/bash

set -x
set -e

${DOWNLOAD_TOOL} -u https://files.pythonhosted.org/packages/a8/17/942c2f167cade0f387b2077299865b6e1d26dca75e1587e12df408b67d9a/lxml-3.2.1.tar.gz

cd ${JARVIS_DEV}

if [ -d "lxml-3.2.1" ]; then
rm -rf lxml-3.2.1
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/lxml-3.2.1.tar.gz
cd lxml-3.2.1

python setup.py install