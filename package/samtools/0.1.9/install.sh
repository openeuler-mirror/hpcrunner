#!/bin/bash
set -x
set -e
wget https://codeload.github.com/samtools/samtools/tar.gz/0.1.9 -O ${JARVIS_DOWNLOAD}/samtools-0.1.9.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/samtools-0.1.9.tar.gz > /dev/null 2>&1
cd samtools-0.1.9
make