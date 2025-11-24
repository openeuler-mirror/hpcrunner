#!/bin/bash
set -e
set -x

install_path=$1

${DOWNLOAD_TOOL} -u https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc2-1.39.0-linux-aarch64.tar.xz -f ldc2-1.39.0-linux-aarch64.tar.xz

tar --no-same-owner -xvf ${JARVIS_DOWNLOAD}/ldc2-1.39.0-linux-aarch64.tar.xz --strip-components 1 -C $install_path
