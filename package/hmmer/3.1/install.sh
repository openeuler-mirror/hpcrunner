#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz

cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/hmmer-3.1b2.tar.gz
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-unknown-linux-gnu'
else
    build_type=''
fi

cd hmmer-3.1b2 
./configure --prefix $1 ${build_type} CFLAGS="-Wno-implicit-function-declaration"
make 
make check
make install
cd easel; make install
