#!/bin/bash
set -x
set -e
SOAPnuke_version="2.1.9"
. ${DOWNLOAD_TOOL} -u  https://github.com/BGI-flexlab/SOAPnuke/archive/refs/tags/SOAPnuke2.1.9.tar.gz -f SOAPnuke2.1.9.tar.gz
cd ${JARVIS_TMP}
rm -rf SOAPnuke-SOAPnuke2.1.9
tar -xvf ${JARVIS_DOWNLOAD}/SOAPnuke2.1.9.tar.gz
cd SOAPnuke-SOAPnuke2.1.9
make -j
mkdir $1/bin
cp SOAPnuke $1/bin

