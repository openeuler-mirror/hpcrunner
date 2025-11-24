#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/scalapack/${BASENAME}

{
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.0.2.tgz
cd ${JARVIS_DEV_VROOT}/scalapack/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/scalapack-2.0.2.tgz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="scalapack-2.0.2.tgz"
REG_META_TYPE="tgz"

[ -d scalapack-2.0.2 ] && echo "Exist DIR:$(pwd)/scalapack-2.0.2" && exit 1

tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.0.2.tgz -C ./
[ ! $? -eq 0 ] && echo "Invalid file: scalapack-2.0.2.tgz" && exit 1

cd scalapack-2.0.2
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

sed -i 's/DBLESZ = 8, INTGSZ = 4, TOTMEM = 4000000/DBLESZ=8,INTGSZ=4,TOTMEM=2000000000/' TESTING/LIN/pdludriver.f
sed -i '212s|int   i, j, m, n, p, q;|int   i, j, m, n, p, q, gcontext;|' REDIST/SRC/pgemraux.c

cp SLmake.inc.example SLmake.inc
if ! [ -z ${LAPACK_CLANG_PATH} ]; then
    echo "ENV LAPACK_CLANG_PATH Found:${LAPACK_CLANG_PATH}"
else
    echo "Not find ENV:LAPACK_CLANG_PATH" && exit 1;
fi
LAPACK_PATH=${LAPACK_CLANG_PATH}
sed -i "58s%-lblas%${LAPACK_PATH}/librefblas.a%g" ./SLmake.inc
sed -i "59s%-llapack%${LAPACK_PATH}/liblapack.a%g" ./SLmake.inc

mkdir build 
cd build  
cmake -DCMAKE_INSTALL_PREFIX="${PATH_INSTALL}" -DBUILD_SHARED_LIBS=ON  -DBUILD_TESTING=ON -DCMAKE_C_COMPILER=mpicc -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration" -DCMAKE_Fortran_COMPILER=mpif90 .. && make -j VERBOSE=1 && make install

cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
        {
            "artifactId": "lapack",
            "version": "",
            "scope": "compile",
            "url": "${LAPACK_PATH}",
            "packaging": "none"
        }
        ]
}
EOF

#make
#mkdir -p $1/lib
#cp *.a $1/lib
#mkdir -p $1/include
#cp SRC/*.h $1/include
} 2>&1 | tee ${JARVIS_DEV_VROOT}/scalapack/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/scalapack/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
