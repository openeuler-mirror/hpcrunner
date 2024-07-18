#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.labri.fr/perso/pelegrin/scotch/distrib/scotch_6.0.9.tar.gz
cd ${JARVIS_TMP}
rm  -rf scotch_6.0.9
tar -xvf ${JARVIS_DOWNLOAD}/scotch_6.0.9.tar.gz
cd scotch_6.0.9
cd src
sed -i "6c AR              = clang" ./Make.inc/Makefile.inc.x86-64_pc_linux2.shlib
sed -i "9c CCS             = clang" ./Make.inc/Makefile.inc.x86-64_pc_linux2.shlib
sed -i "11c CCD             = clang" ./Make.inc/Makefile.inc.x86-64_pc_linux2.shlib
ln -s ./Make.inc/Makefile.inc.x86-64_pc_linux2.shlib Makefile.inc
make scotch
mkdir $1/bin -p
mkdir $1/lib -p
cp ../bin/* $1/bin
cp ../lib/* $1/lib
