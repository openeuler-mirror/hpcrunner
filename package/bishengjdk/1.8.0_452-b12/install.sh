#!/bin/bash
set -e
set -x
mkdir -p ${JARVIS_LOG_DIR}/bishengjdk/1.8.0_452-b12
{
export hpckit_ver="8u452-b12"
../meta.sh $1
} 2>&1 | tee ${JARVIS_LOG_DIR}/bishengjdk/1.8.0_452-b12/tee_install_$(date +%Y%m%d%H%M%S).xlog
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
set +x
exit ${res}