set -x
set -e
[ -z "${CC}" ] && echo "Invalid compiler, ENV:${CC}" && exit 1

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/metis/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://github.com/KarypisLab/GKlib/archive/refs/heads/master.zip -f GKlib-master.zip
. ${DOWNLOAD_TOOL} -u https://github.com/KarypisLab/METIS/archive/refs/tags/v5.2.1.tar.gz -f metis-5.2.1.tar.gz
cd ${WORK_DIR}
[ -d metis-5.2.1  ] && echo "Exist DIR:$(pwd)/metis-5.2.1" && exit 1
mkdir -p metis-5.2.1

### default dir:METIS-5.2.1
tar  -xf ${JARVIS_DOWNLOAD}/metis-5.2.1.tar.gz -C ./metis-5.2.1 --strip-components=1
### default dir:
[ ! $? -eq 0 ] && echo "Invalid file: metis-5.2.1.tar.gz" && exit 1

unzip -o ${JARVIS_DOWNLOAD}/GKlib-master.zip  -d ${WORK_DIR}/metis-5.2.1/
[ ! $? -eq 0 ] && echo "Invalid file: GKlib-master.tar.gz" && exit 1
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/metis-5.2.1.tar.gz  | awk '{print $1}');$(md5sum ${JARVIS_DOWNLOAD}/GKlib-master.zip  | awk '{print $1}')"
REG_META_HTYPE="md5;md5"
REG_META_PACKAGE="metis-5.2.1.tar.gz;GKlib-master.zip"
REG_META_TYPE="tgz;zip"

cd metis-5.2.1/GKlib-master
sed -i '/^cd $(BUILDDIR) && cmake $(CURDIR) $(CONFIG_FLAGS)/c\cd $(BUILDDIR) && cmake $(CURDIR) $(CONFIG_FLAGS) -DCMAKE_INSTALL_LIBDIR=lib' Makefile
make config shared=1 cc=${CC} gdb=1 debug=1  openmp=1 prefix=${PATH_INSTALL}/GKlib
make verbose=1
make install
ln -sf ${PATH_INSTALL}/GKlib/lib/libGKlib.so.0.0.1 ${PATH_INSTALL}/GKlib/lib/libGKlib.so

cd ..
make config shared=1 cc=${CC} gdb=1 debug=1  openmp=1 prefix=${PATH_INSTALL} gklib_path=${PATH_INSTALL}/GKlib
make verbose=1
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
