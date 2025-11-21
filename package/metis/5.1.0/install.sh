set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/metis/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://src.fedoraproject.org/lookaside/pkgs/metis/metis-5.1.0.tar.gz/5465e67079419a69e0116de24fce58fe/metis-5.1.0.tar.gz -f metis-5.1.0.tar.gz
cd ${WORK_DIR}
rm -rf metis-5.1.0
tar -xf ${JARVIS_DOWNLOAD}/metis-5.1.0.tar.gz

REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/metis-5.1.0.tar.gz | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="metis-5.1.0.tar.gz"
REG_META_TYPE="tgz"

cd metis-5.1.0
make config prefix=$1 shared=1
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
