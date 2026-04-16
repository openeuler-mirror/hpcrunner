#!/bin/bash
set -e
export hpckit_ver="25.2.1"
../meta.sh $1
MODULEFILE_PATH=$1/HPCKit/25.2.1/modulefiles/bisheng/kml25.2.1/kblas
if [ -f "$MODULEFILE_PATH/multi" ]; then
    sed -i '71s|fi|}|' $MODULEFILE_PATH/multi
    sed -i '70s|fi|}|' $MODULEFILE_PATH/serial-locking
    sed -i '70s|fi|}|' $MODULEFILE_PATH/serial-nolocking
    echo "Successfuly patched modulefile syntax"
else
    echo "Warning : Modulefile not found at $MODULEFILE_PATH/multi"
fi
