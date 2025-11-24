#!/bin/bash
set -x
set -e
PREFIX=$1
#hpckit_ver="24.0.RC1"
. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_jdk/bisheng-jdk-${hpckit_ver}-linux-aarch64.tar.gz
chmod u+x $JARVIS_DOWNLOAD/bisheng-jdk-${hpckit_ver}-linux-aarch64.tar.gz
tar -zxvf $JARVIS_DOWNLOAD/bisheng-jdk-${hpckit_ver}-linux-aarch64.tar.gz -C ${PREFIX} --strip-components=1
[ ! $? -eq 0 ] && echo "Invalid file: bisheng-jdk-${hpckit_ver}-linux-aarch64.tar.gz" && exit 1
cat > ${PREFIX}/module_tail.modulefile << EOF
setenv JAVA_HOME ${PREFIX}
EOF
echo -e "bisheng-jdk-${hpckit_ver}-linux-aarch64 has installed in your environment."
