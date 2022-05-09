#!/bin/bash
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-aarch64.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/cmake-3.23.1-linux-aarch64.tar.gz -C $1 --strip-components=1