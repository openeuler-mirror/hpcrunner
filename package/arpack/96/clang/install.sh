#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.caam.rice.edu/software/ARPACK/SRC/arpack96.tar.gz
. ${DOWNLOAD_TOOL} -u https://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/arpack96.tar.gz
tar zxvf ${JARVIS_DOWNLOAD}/patch.tar.gz
cd ARPACK
sed -i "28c\home = '${JARVIS_TMP}'/ARPACK" ARmake.inc
sed -i '35c\PLAT = INTEL' ARmake.inc
sed -i '104c\FC = flang' ARmake.inc
sed -i '105c\#FFLAGS = -0 -cg89' ARmake.inc
sed -i '115c\MAKE = /usr/bin/make' ARmake.inc
sed -i '120c\SHELL = /usr/bin/sh' ARmake.inc
sed -i '24c\*      EXTERNAL    ETIME' UTIL/second.f
make lib
