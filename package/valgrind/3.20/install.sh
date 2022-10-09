#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u git://sourceware.org/git/valgrind.git -t git
cd ${JARVIS_DOWNLOAD}
cd valgrind
./autogen.sh
./configure --prefix=$1
make -j
make install