#!/bin/bash
set -x
set -e

. ${JARVIS_LIBSHELL}

check_rpms_installed patch mesa-libEGL-devel mesa-libGL-devel libX11-devel

${DOWNLOAD_TOOL} -u https://download.qt.io/archive/qt/5.12/5.12.12/single/qt-everywhere-src-5.12.12.tar.xz

SCRIPT_DIR=$(dirname $(readlink -f $0))
PATH_INSTALL=$1
BASENAME=$(basename "$1")
WORK_DIR=${JARVIS_DEV_VROOT}/qt5/${BASENAME}
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}

if [ -d "qt-everywhere-src-5.12.12" ]; then
rm -rf qt-everywhere-src-5.12.12
fi
tar --no-same-owner -xvf ${JARVIS_DOWNLOAD}/qt-everywhere-src-5.12.12.tar.xz
cd qt-everywhere-src-5.12.12


sed -i "8c\#include <stdexcept>" qtlocation/src/3rdparty/mapbox-gl-native/platform/default/bidi.cpp
sed -i "2c\#include <cstdint>" qtlocation/src/3rdparty/mapbox-gl-native/src/mbgl/util/convert.cpp

patch qtbase/src/gui/configure.json $SCRIPT_DIR/configure.patch

./configure -prefix $PATH_INSTALL -opensource -confirm-license -nomake tests

gmake -j16
gmake install
