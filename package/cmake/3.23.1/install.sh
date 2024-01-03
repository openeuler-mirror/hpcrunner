#!/bin/bash
set -e
cmake_ver='3.23.1'
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}-linux-`arch`.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/cmake-${cmake_ver}-linux-`arch`.tar.gz -C $1 --strip-components=1