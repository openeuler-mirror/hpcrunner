#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/BenLangmead/bowtie2/archive/refs/tags/v2.4.5.tar.gz -f bowtie2-2.4.5.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/bowtie2-2.4.5.tar.gz -C ${JARVIS_TMP}
cd bowtie2-2.4.5
if [ `arch` == "aarch64" ]; then
    sed -i 's/\CXXFLAGS += -std=c++11/\CXXFLAGS += -std=c++11 /g' Makefile
    . ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/simd-everywhere/simde/archive/refs/tags/v0.7.2.tar.gz
    tar -xzf ${JARVIS_DOWNLOAD}/v0.7.2.tar.gz -C .
    cp -r simde-0.7.2/simde ./third_party
    make -j
    make static-libs -j && make STATIC_BUILD=1 -j
    mkdir -p $1/bin
    cp bowtie2*  $1/bin
else
    make -j
    make static-libs -j && make STATIC_BUILD=1 -j
    mkdir -p $1/bin
    cp bowtie2*  $1/bin
fi
