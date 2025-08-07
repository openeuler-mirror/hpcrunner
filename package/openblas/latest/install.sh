#!/bin/bash
set -e
export openblas_ver=`curl https://github.com/OpenMathLib/OpenBLAS/releases|grep OpenBLAS|grep .tar.gz|awk -F "OpenBLAS-" '{print $2}'|awk -F ".tar.gz" '{print $1}'|awk NR==1`
../meta.sh $1
