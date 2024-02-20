#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.code-aster.org/FICHIERS/aster-full-src-14.6.0-1.noarch.tar.gz
#yum -y install zlib* lapack* blas* python3.aarch64 python3-devel.aarch64 cmake3 boost-python* boost boost-devel numpy* python-numpy flex bison tcl tk
#export CC=gcc CXX=g++ FC=gfortran
cd ${JARVIS_TMP}
rm -rf aster-full-src-14.6.0
tar -xzvf ${JARVIS_DOWNLOAD}/aster-full-src-14.6.0-1.noarch.tar.gz
cd aster-full-src-14.6.0

sed -i "354s/)/,'aarch64')/g"  setup.py
sed -i "1537a\      'aarch64': 'shell|script|aarch64', "  as_setup.py

GCC_PATH=`which gcc`
GCC_PATH=${GCC_PATH%/*/*}

sed -i '94i\CC='\'''${GCC_PATH}'/bin/gcc'\''\
CXX='\'''${GCC_PATH}'/bin/g++'\''\
F90='\'''${GCC_PATH}'/bin/gfortran'\''\
LD=F90\
CXXFLAGS="-std=c++11"\
CXXLIB='\''-L'${GCC_PATH}'/lib64 -lstdc++'\''' setup.cfg

sed -i "187s/unset LD ; export LDFLAGS='{0}' ; //g" products.py

cd SRC/
tar xvf aster-14.6.0.tgz
sed -i "103s/:/ or self.env.DEST_CPU == 'aarch64':/g" aster-14.6.0/bibfor/wscript
sed -i '224i\        curr_idmess = idmess.split("\\0")\
        x = curr_idmess[0].split("_")'  ./aster-14.6.0/bibpyt/Utilitai/Utmess.py
sed -i '226d' ./aster-14.6.0/bibpyt/Utilitai/Utmess.py
tar cvzf aster-14.6.0.tgz aster-14.6.0
rm -rf aster-14.6.0
cd ..
echo y | python3 setup.py --prefix=$1
