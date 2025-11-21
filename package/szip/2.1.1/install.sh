#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog

mkdir -p ${JARVIS_DEV_VROOT}/szip/${BASENAME}
szip_ver='2.1.1'

{
  # 下载 szip
  . ${DOWNLOAD_TOOL} -u https://distfiles.macports.org/szip/szip-${szip_ver}.tar.gz 
  cd ${JARVIS_DEV_VROOT}/szip/${BASENAME}

  # 计算 MD5 值
  REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/szip-${szip_ver}.tar.gz | awk '{print $1}')
  REG_META_HTYPE="md5"
  REG_META_PACKAGE="szip-${szip_ver}.tar.gz"
  REG_META_TYPE="tar.gz"

  # 检查目录是否存在
  [ -d szip-${szip_ver} ] && echo "Exist DIR:$(pwd)/szip-${szip_ver}" && exit 1

  # 解压文件
  tar xvf ${JARVIS_DOWNLOAD}/szip-${szip_ver}.tar.gz
  [ ! $? -eq 0 ] && echo "Invalid file: szip-${szip_ver}.tar.gz" && exit 1

  # 进入解压后的目录
  cd szip-${szip_ver}
  REG_PROJECT_URL=$(pwd)
  REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

  echo "BUILD DIR:$(pwd)"

  # 配置和编译
  ./configure --prefix=$1 --enable-netcdf-4 --enable-shared
  make -j
  make install

  # 生成安装记录文件
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/szip/${BASENAME}/${log_file}

res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/szip/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
