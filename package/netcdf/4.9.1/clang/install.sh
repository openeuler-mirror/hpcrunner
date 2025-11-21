#!/bin/bash
set -x
set -e
set -o posix
export netcdf_c_version='4.9.1'
export netcdf_f_version='4.6.1'
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}
{
../../clang/meta.sh $1 "${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}"
} 2>&1 | tee ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
