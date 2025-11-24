#!/bin/bash
PATCH_DIR=$1
SRC_DIR=$2
cd $2/libs/python
patch -p1 <  ${PATCH_DIR}/patches/0474de0f6cc9c6e7230aeb7164af2f7e4ccf74bf.patch


