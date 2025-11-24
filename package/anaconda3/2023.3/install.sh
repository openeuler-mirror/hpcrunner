#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/Anaconda3/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-aarch64.sh
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/Anaconda3-2023.03-Linux-aarch64.sh| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="Anaconda3-2023.03-Linux-aarch64.sh"
REG_META_TYPE="sh"
cd ${JARVIS_DEV_VROOT}/Anaconda3/${BASENAME}
#yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver -y
if true; then
bash ${JARVIS_DOWNLOAD}/Anaconda3-2023.03-Linux-aarch64.sh -u -b -p ${PATH_INSTALL}
source ${PATH_INSTALL}/etc/profile.d/conda.sh
conda config --set auto_activate_base false
fi
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
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

cat > ${PATH_INSTALL}/conda_config.yaml << EOF
auto_activate_base: False
envs_dirs: []
EOF

cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
set CONDA_SH "${PATH_INSTALL}/etc/profile.d/conda.sh"
set CONDA_CFG "${PATH_INSTALL}/conda_config.yaml"
set CONDARC "${PATH_INSTALL}/conda_config.yaml"

setenv CONDA_SH "${PATH_INSTALL}/etc/profile.d/conda.sh"
setenv CONDA_CFG "${PATH_INSTALL}/conda_config.yaml"
setenv CONDARC "${PATH_INSTALL}/conda_config.yaml"
if { [module-info mode load] } {
puts stderr "Conda Env: CONDA_SH=\${CONDA_SH}"
puts stderr "Enable conda: source \\\${CONDA_SH}"
puts stderr "Conda Env: CONDARC=\${CONDARC}"
puts stderr "Conda Env: CONDA_CFG=\${CONDA_CFG}"
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/Anaconda3/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/Anaconda3/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
