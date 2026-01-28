#!/bin/bash
set -x
set -e

. $CHECK_ROOT && yum install -y git java-17-openjdk java-17-openjdk-devel
update-alternatives --set java /usr/lib/jvm/java-17-openjdk-17.0.15.6-4.oe2203sp4.aarch64/bin/java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

cd ${JARVIS_TMP}
rm -rf picard
git config --global --add core.compression -1
git config --global http.sslVerify False
git clone $JARVIS_PROXY/broadinstitute/picard.git
cd picard
./gradlew shadowJar
cp -a build/ $1


