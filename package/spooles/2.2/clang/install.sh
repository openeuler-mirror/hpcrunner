#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/linalg/spooles/spooles.2.2.tgz
cd ${JARVIS_TMP}
mkdir SPOOLES.2.2
tar zxvf ${JARVIS_DOWNLOAD}/spooles.2.2.tgz -C SPOOLES.2.2
cd SPOOLES.2.2
sed -i '14c\ CC = clang' Make.inc
sed -i '15c\#CC = /usr/lang-4.0/bin/cc' Make.inc
sed -i '9c\      draw.c \' Tree/src/makeGlobalLib
make lib
