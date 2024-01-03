#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/evaleev/libint/archive/v2.6.0.tar.gz -f libint-2.6.0.tar.gz
cd ${JARVIS_TMP}
#export GCC_LIBS=/home/HT3/HPCRunner2/software/libs/kgcc9
rm -rf libint-2.6.0
tar -xvf ${JARVIS_DOWNLOAD}/libint-2.6.0.tar.gz
cd libint-2.6.0
./autogen.sh
mkdir build
cd build

array=(${LD_LIBRARY_PATH//:/ })
for var in ${array[@]}
do
   if [[ -e $var/libgmp.so ]];then
	gmp_path=${var%/*}
   fi
   if [[ -e $var/libboost_thread.so ]];then
        boost_path=${var%/*}
   fi
done

if [ ! -n "$gmp_path" ];then
	echo "Please load gmp."
	exit 1
fi

if [ ! -n "$boost_path"	];then
        echo "Please load boost."
        exit 1
fi


export LDFLAGS="-L$gmp_path/lib -L$boost_path/lib"
export CPPFLAGS="-I$gmp_path/include -I$boost_path/include"
../configure CXX=mpicxx --enable-eri=1 --enable-eri2=1 --enable-eri3=1 --with-max-am=4 --with-eri-max-am=4,3 --with-eri2-max-am=6,5 --with-eri3-max-am=6,5 --with-opt-am=3 --enable-generic-code --disable-unrolling --with-libint-exportdir=libint_cp2k_lmax4
make export
tar -xvf libint_cp2k_lmax4.tgz
cd libint_cp2k_lmax4
./configure --prefix=$1 CC=mpicc CXX=mpicxx FC=mpifort --enable-fortran --enable-shared
make -j
make install
