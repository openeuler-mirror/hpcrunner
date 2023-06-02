#download from https://github.com/jratcliff63367/sse2neon  https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
#module  load  bisheng/2.1.0    
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/jratcliff63367/sse2neon/archive/refs/heads/master.zip -f sse2neon-master.zip
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
cd ${JARVIS_TMP}
rm -rf bwa-0.7.17  sse2neon-master
tar  -xvf ${JARVIS_DOWNLOAD}/bwa-0.7.17.tar.bz2
unzip ${JARVIS_DOWNLOAD}/sse2neon-master.zip
cd bwa-0.7.17
bisheng_includedir=`which clang`
bisheng_includedir=${bisheng_includedir%/*/*}/include
cp ${JARVIS_TMP}/sse2neon-master/SSE2NEON.h ${bisheng_includedir}
sed -i "1s/gcc/clang/g" Makefile
sed -i "14s%$%-I${bisheng_includedir}%g" Makefile
sed -i "29s/<emmintrin.h>/<SSE2NEON.h>/g" ksw.c
sed -i "33s%^%//%g" rle.h
make 
mkdir -p $1/bin
cp -r ../bwa-0.7.17/* $1/bin
rm -rf ${bisheng_includedir}/SSE2NEON.h
