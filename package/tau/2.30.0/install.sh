#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
# install PDT
#tar -zxvf ${JARVIS_DOWNLOAD}/pdt.tgz
#cd pdtoolkit-3.25.1/
#./configure -GNU -prefix=$1/PDT
#make -j install
# install TAU, using tau with external package
#tar -zxvf ${JARVIS_DOWNLOAD}/tau-2.30.0.tar.gz
#cd tau-2.30.0/
#./configure -openmp -bfd=download -unwind=download -mpi -pdt=$1/PDT/ -pdt_c++=g++ -mpi
#export PATH=$1/tau-2.30.0/arm64_linux/bin:$PATH
#usage: mpirun --allow-run-as-root -np 128 -x OMP_NUM_THREADS=1 --mca btl ^openib  tau_exec  vasp_std
#pprof

. ${DOWNLOAD_TOOL} -u https://www.cs.uoregon.edu/research/tau/tau_releases/tau-2.30.tar.gz
rm -rf tau-2.30
tar -zxvf ${JARVIS_DOWNLOAD}/tau-2.30.tar.gz
cd tau-2.30
sed -i '3710c   # Are we on a Fujitsu FX aarch64 system with Fujitsu compilers in the path?' configure
sed -i '3711c   #found_compiler=`which mpiFCC 2>/dev/null`'                                  configure
sed -i '3712c   #if [ "x$found_compiler" != "x" -a -x $found_compiler ]; then'               configure
sed -i '3713c   #   echo "TAU: Using mpiFCC, mpifcc, and mpifrt as C++, C, and Fortran compilers respectively."' configure
sed -i '3714c       cxx_compiler=mpicxx'                                                     configure
sed -i '3715c       c_compiler=mpicc'                                                        configure
sed -i '3716c       fortran_compiler=mpif90'                                                 configure
sed -i '3717c   #fi'                                                                         configure

./configure -mpi -prefix=$1
make clean
make -j
make install
