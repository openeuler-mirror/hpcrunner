#!/bin/bash

set -x
set -e

${DOWNLOAD_TOOL} -u https://files.pythonhosted.org/packages/04/06/3904f93f05a4734e4daec069aba9d590f53db899a6a81e8e79ffe6602466/rdflib-2.4.2.tar.gz

${DOWNLOAD_TOOL} -u https://files.pythonhosted.org/packages/29/17/f98a2cb39bb5b40357fd54fba1dd105e224a447a91867ac5c4ef6f8f0191/setuptools-0.6c8.tar.gz

cd ${JARVIS_DEV}

if [ -d "setuptools-0.6c8" ]; then
rm -rf setuptools-0.6c8
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/setuptools-0.6c8.tar.gz

cd setuptools-0.6c8
python setup.py install
cd ..

if [ -d "rdflib-2.4.2" ]; then
rm -rf rdflib-2.4.2
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/rdflib-2.4.2.tar.gz

cd rdflib-2.4.2
python setup.py install