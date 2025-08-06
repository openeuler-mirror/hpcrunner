#!/bin/bash
set -x
set -e


if [[ $UseGitee -eq 1 ]]; then
. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/fftw3/archive/refs/tags/fftw-${fftw_ver}.tar.gz -f fftw-${fftw_ver}.tar.gz
else
. ${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-${fftw_ver}.tar.gz -f fftw-${fftw_ver}.tar.gz
fi

cd ${JARVIS_TMP}
rm -rf fftw-${fftw_ver}
tar -xvf ${JARVIS_DOWNLOAD}/fftw-${fftw_ver}.tar.gz
cd fftw-${fftw_ver}
./configure --prefix=$1 --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-long-double --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install


