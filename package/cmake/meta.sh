#!/bin/bash
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}-linux-`arch`.tar.gz
tar -xzvf ${JARVIS_DOWNLOAD}/cmake-${cmake_ver}-linux-`arch`.tar.gz -C $1 --strip-components=1
