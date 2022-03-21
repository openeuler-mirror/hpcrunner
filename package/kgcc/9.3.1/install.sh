#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/gcc-9.3.1-2021.03-aarch64-linux.tar.gz -C $1 --strip-components=1