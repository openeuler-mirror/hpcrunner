#!/bin/bash
set -e
cd ${JARVIS_TMP}
rpm -e boostkit-kml
rpm --force --nodeps -ivh ${JARVIS_ROOT}/package/kml/1.4.0/gcc/*.rpm
cp -rf ${JARVIS_ROOT}/package/kml/1.4.0/gcc/libklapack_full.so /usr/local/kml/lib