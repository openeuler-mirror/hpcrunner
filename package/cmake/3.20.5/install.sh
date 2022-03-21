#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/cmake-3.20.5-linux-aarch64.tar.gz -C $1 --strip-components=1