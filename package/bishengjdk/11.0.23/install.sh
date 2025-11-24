#!/bin/bash
set -e
set -x
mkdir -p ${JARVIS_LOG_DIR}/bishengjdk/11.0.23
{
export hpckit_ver="11.0.23"
../meta.sh $1
} 2>&1 | tee ${JARVIS_LOG_DIR}/bishengjdk/11.0.23/tee_install_$(date +%Y%m%d%H%M%S).xlog
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
set +x
exit ${res}
