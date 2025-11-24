#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/bazel/${BASENAME}
{
${DOWNLOAD_TOOL} -u https://github.com/bazelbuild/bazel/releases/download/5.3.0/bazel-5.3.0-linux-arm64 -f bazel-5.3.0-linux-arm64
mkdir -p ${PATH_INSTALL}/bin
cd ${PATH_INSTALL}/bin
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/bazel-5.3.0-linux-arm64| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="bazel-5.3.0-linux-arm64"
REG_META_TYPE="binary"

REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
echo "REG_META_PACKAGE:${REG_META_PACKAGE}"
echo "REG_META_HVALUE:${REG_META_HVALUE}"

cp ${JARVIS_DOWNLOAD}/bazel-5.3.0-linux-arm64 ${PATH_INSTALL}/bin/bazel -ar

chmod +x ${PATH_INSTALL}/bin/bazel

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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/bazel/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/bazel/${BASENAME}/${log_file} ${1}
set +x
exit ${res}

