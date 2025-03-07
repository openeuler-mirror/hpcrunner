#!/bin/bash

set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/stephaneguindon/phyml/archive/refs/tags/v3.3.20220408.tar.gz
cd ${JARVIS_TMP}
rm -rf phyml-3.3.20220408
tar -xvf ${JARVIS_DOWNLOAD}/v3.3.20220408.tar.gz
cd phyml-3.3.20220408
sh autogen.sh
./configure --prefix=$1 --enable-phyml-mpi

HEADER_FILE="src/utilities.h"
if grep -q '#elif defined(__ARM_NEON__) || defined(__ARM_NEON)' "$HEADER_FILE"; then
    echo "NEON code already exists in $SOURCE_FILE. Skipping insertion."
else
    sed -i '43a \#elif defined(__ARM_NEON__) || defined(__ARM_NEON)\n#include <arm_neon.h>' "$HEADER_FILE"
    sed -i '778a \#elif defined(__ARM_NEON__) || defined(__ARM_NEON)\nfloat64x2_t *_tPij1, *_tPij2, *_pmat1plk1, *_pmat2plk2, *_plk0, *_l_ev, *_r_ev, *_prod_left, *_prod_rght;' "$HEADER_FILE"
fi

make
make install
