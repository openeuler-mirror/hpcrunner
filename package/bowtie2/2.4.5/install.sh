#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.4.5.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/v2.4.5.tar.gz -C ${JARVIS_TMP}
cd bowtie2-2.4.5
if [ `arch` == "aarch64" ]; then
    sed -i 's/\CXXFLAGS += -std=c++11/\CXXFLAGS += -std=c++11 -stdlib=libc++/g' Makefile
    . ${DOWNLOAD_TOOL} -u https://github.com/simd-everywhere/simde/archive/refs/tags/v0.7.2.tar.gz
    tar -xzf ${JARVIS_DOWNLOAD}/v0.7.2.tar.gz -C .
    cp -r simde-0.7.2/simde ./third_party
    make -j
    make static-libs -j && make STATIC_BUILD=1 -j
    mkdir -p ${JARVIS_LIBS}/bisheng2.1.0/bowtie2/2.4.5/bin
    cp bowtie2*  ${JARVIS_LIBS}/bisheng2.1.0/bowtie2/2.4.5/bin
else
    make -j
    make static-libs -j && make STATIC_BUILD=1 -j
    mkdir -p ${JARVIS_LIBS}/gcc9/bowtie2/2.4.5/bin
    cp bowtie2*  ${JARVIS_LIBS}/gcc9/bowtie2/2.4.5/bin
fi
