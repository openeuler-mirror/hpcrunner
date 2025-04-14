#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://jaist.dl.sourceforge.net/project/bowtie-bio/bowtie2/2.4.1/bowtie2-2.4.1-source.zip
. ${DOWNLOAD_TOOL} -u https://github.com/simd-everywhere/simde/archive/refs/heads/master.zip -f simde-master.zip
. ${DOWNLOAD_TOOL} -u https://raw.githubusercontent.com/jratcliff63367/sse2neon/refs/heads/master/SSE2NEON.h
cd ${JARVIS_TMP}
rm -rf bowtie2-2.4.1
unzip -q ${JARVIS_DOWNLOAD}/bowtie2-2.4.1-source.zip
cd bowtie2-2.4.1
mkdir -p third_party/simde/simde/x86
export NO_TBB=1
export POPCNT_CAPABILITY=0
unzip -q ${JARVIS_DOWNLOAD}/simde-master.zip
cp -a simde-master/simde third_party/simde/
cp -a ${JARVIS_DOWNLOAD}/SSE2NEON.h third_party/simde/simde/x86/
make all
mkdir -p $1/bin
cp bowtie2* $1/bin
