#!/bin/bash
#. $CHECK_ROOT && yum install -y git java-1.8.0-openjdk
set -x
set -e
cd ${JARVIS_TMP}
rm -rf picard
git config --global --add core.compression -1
git config --global http.sslVerify False
git clone $JARVIS_PROXY/broadinstitute/picard.git
cd picard
./gradlew shadowJar
cp -a build/ $1


