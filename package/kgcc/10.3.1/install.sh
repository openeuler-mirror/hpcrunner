#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-10.3.1-2021.09-aarch64-linux.tar.gz -C $1 --strip-components=1 