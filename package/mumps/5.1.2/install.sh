#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://graal.ens-lyon.fr/MUMPS/MUMPS_5.1.2.tar.gz
cd ${JARVIS_TMP}
rm -rf MUMPS_5.1.2
tar -xvf ${JARVIS_DOWNLOAD}/MUMPS_5.1.2.tar.gz
cd MUMPS_5.1.2
LAPACK_PATH=${LAPACK_PATH}
SCALPACK_PATH=${SCALPACK_PATH}
MPI_PATH=${MPI_PATH}
OPENBLAS_PATH=${OPENBLAS_PATH}
export MUMPS_PATH=$1
mkdir -p lib
mkdir -p $1/include
cp Make.inc/Makefile.inc.generic ./Makefile.inc
sed -i 's/f90/mpifort/g' ./Makefile.inc
sed -i 's/CC      = cc/CC = mpicc/g' ./Makefile.inc
sed -i '94c LIBEXT  = .so' ./Makefile.inc
sed -i '107c AR = $(CC) -shared $(OPTC) -o' ./Makefile.inc
sed -i '110c RANLIB = echo' ./Makefile.inc
sed -i '115c LAPACK = -Wl,-rpath,${LAPACK_PATH} -L${LAPACK_PATH} -llapack' ./Makefile.inc
sed -i '118c SCALAP = -Wl,-rpath,${SCALPACK_PATH}/lib -L${SCALPACK_PATH}/lib -lscalapack' ./Makefile.inc
sed -i '121c INCPAR = -I${MPI_PATH}/include' ./Makefile.inc
sed -i '124c LIBPAR = $(SCALAP) $(LAPACK) -L${MPI_PATH}/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi' ./Makefile.inc
sed -i '134c LIBBLAS = -Wl,-rpath,${OPENBLAS_PATH}/lib -L${OPENBLAS_PATH}/lib -lopenblas' ./Makefile.inc
sed -i '153c OPTF = -DALLOW_NON_INIT ${CFLAGS} -fPIC -Wno-argument-mismatch' ./Makefile.inc
sed -i '154c OPTC = ${CFLAGS} -fPIC' ./Makefile.inc
sed -i '155c OPTL = ${CFLAGS} -fPIC' ./Makefile.inc
sed -i 's/$@/$(MUMPS_PATH)/g ' ./Makefile
make clean
make alllib all
cp -r lib/* $1/
cp -r include/* $1/include/