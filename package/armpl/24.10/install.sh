#!/bin/bash
set -e
set -x

${DOWNLOAD_TOOL} -u https://developer.arm.com/-/cdn-downloads/permalink/Arm-Performance-Libraries/Version_24.10/arm-performance-libraries_24.10_rpm_gcc.tar
PATH_INSTALL=$1

cd ${JARVIS_TMP}
tar --no-same-owner -xvf ${JARVIS_DOWNLOAD}/arm-performance-libraries_24.10_rpm_gcc.tar
cd arm-performance-libraries_24.10_rpm
./arm-performance-libraries_24.10_rpm.sh -a -i ${PATH_INSTALL}


cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
module use ${PATH_INSTALL}/modulefiles
module load armpl/24.10.0_gcc
EOF
