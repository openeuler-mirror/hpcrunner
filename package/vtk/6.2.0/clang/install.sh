#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/vtk/${BASENAME}
mkdir -p ${WORK_DIR}
{
${DOWNLOAD_TOOL} -u http://www.vtk.org/files/release/6.2/VTK-6.2.0.tar.gz

cd ${WORK_DIR}
[ -d VTK-6.2.0  ] && echo "Exist DIR:$(pwd)/VTK-6.2.0" && exit 1
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/VTK-6.2.0.tar.gz
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/VTK-6.2.0.tar.gz | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="VTK-6.2.0.tar.gz"
REG_META_TYPE="tgz"

cd VTK-6.2.0

sed -i '169s|.*|    string(REGEX MATCH "[1-9]+\\\\.[0-9]\\\\.[0-9]*"|' CMake/GenerateExportHeader.cmake
sed -i '30s|.*|  string (REGEX MATCH "[1-9]+\\\\.[0-9]\\\\.[0-9]*"|' CMake/vtkCompilerExtras.cmake

mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$PATH_INSTALL \
         -DCMAKE_C_FLAGS="-Wno-implicit-function-declaration" \
         -DCMAKE_CXX_FLAGS="-std=c++14 -Wno-implicit-function-declaration"

make -j 16
make install

REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
   
        ]
}
EOF

} 2>&1 | tee ${WORK_DIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORK_DIR}/${log_file} ${1}
set +x
exit ${res}
