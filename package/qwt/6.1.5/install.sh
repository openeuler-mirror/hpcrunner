#!/bin/bash
set -x
set -e
yum install -y qt5-devel qt5-qtbase-private-devel qt5-qttools-static qt5-qtsvg-devel
. ${DOWNLOAD_TOOL} -u https://downloads.sourceforge.net/qwt/qwt-6.1.5.tar.bz2
cd ${JARVIS_TMP}
rm -rf qwt-6.1.5
tar -xjf ${JARVIS_DOWNLOAD}/qwt-6.1.5.tar.bz2
cd qwt-6.1.5
sed -i "22c \    QWT_INSTALL_PREFIX    = $1" qwtconfig.pri
qmake-qt5 qwt.pro
make -j
make install
