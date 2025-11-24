#!/bin/bash
set -e
set -x

. ${JARVIS_LIBSHELL}

check_rpm_install "guile-devel"
if [ $? != 0 ]; then
exit 1
fi

install_path=$1
${DOWNLOAD_TOOL} -u https://codeload.github.com/NanoComp/libctl/tar.gz/v4.5.0 -f libctl-v4.5.0.tar.gz

cd ${JARVIS_TMP}

if [ -d "libctl-4.5.0" ]; then
rm -rf libctl-4.5.0
fi
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/libctl-v4.5.0.tar.gz
cd libctl-4.5.0
bash autogen.sh --enable-shared --prefix=$install_path
make -j
make install