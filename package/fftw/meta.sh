#!/bin/bash
set -x
set -e

export UseGitee=0
if [[ $UseGitee -eq 1 ]]; then
#. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/fftw3/archive/refs/tags/fftw-${fftw_ver}.tar.gz -f fftw-${fftw_ver}.tar.gz
cd ${JARVIS_TMP}
git clone https://gitee.com/kp-hpc-mod/fftw3.git
mv fftw3 fftw-${fftw_ver}
cd fftw-${fftw_ver}
git checkout fftw-${fftw_ver}

else
. ${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-${fftw_ver}.tar.gz -f fftw-${fftw_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf fftw-${fftw_ver}
tar -xvf ${JARVIS_DOWNLOAD}/fftw-${fftw_ver}.tar.gz
cd fftw-${fftw_ver}
fi


./configure --prefix=$1 --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-long-double --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install


