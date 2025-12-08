#!/bin/bash
# please build with gcc/icc+openmpi
# gcc: export CC=mpicc
# icc: export CC=mpiicc
set -x
set -e
version='3.4.6'
. $CHECK_ROOT && yum install -y texlive* gnuplot perl-Pod-LaTeX perl-HTML-Parser ghostscript
. ${DOWNLOAD_TOOL} -u https://web.cels.anl.gov/projects/darshan/releases/darshan-${version}.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/darshan-${version}.tar.gz
cd darshan-${version}
./prepare.sh
# install darshan runtime to collect IO info.
cd darshan-runtime
mkdir -p $1/runtime
./configure --prefix=$1/runtime --with-mem-align=8 --with-log-path-by-env=DARSHAN_LOG_DIR_PATH --with-jobid-env=NONE
make -j 
make install
# install darshan util to analysis IO info.
cd ../darshan-util
mkdir -p $1/util
./configure --prefix=$1/util
make -j 
make install