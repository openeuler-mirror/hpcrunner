#!/bin/bash
set -e
set -x

install_path=$1

${DOWNLOAD_TOOL} -u https://static.rust-lang.org/dist/rust-1.70.0-aarch64-unknown-linux-gnu.tar.gz -f rust-1.70.0-aarch64-unknown-linux-gnu.tar.gz

if [ ! -d "${JARVIS_DEV}/rust-1.70.0-aarch64-unknown-linux-gnu" ]; then
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/rust-1.70.0-aarch64-unknown-linux-gnu.tar.gz -C ${JARVIS_DEV}
fi

cd ${JARVIS_DEV}/rust-1.70.0-aarch64-unknown-linux-gnu

./install.sh --prefix=$install_path