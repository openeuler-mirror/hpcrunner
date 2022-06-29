#!/bin/bash
cd ..
# release mfem src code
rm -rf tmp/mfem-4.4
tar xzvf ./downloads/mfem-4.4.tar.gz -C tmp/
# copy templates
cp -rf templates/mfem/4.4/data.mfem.amd.cpu.config ./
# switch to config
./jarvis -use data.mfem.amd.cpu.config
# install dependency
./jarvis -dp
# generate environment
./jarvis -e
# environment setup
source env.sh
# build
./jarvis -b
# run
# ./jarvis -r
# # perf
# ./jarvis -p
# # kperf
# ./jarvis -kp
# # gpu nsysperf
# ./jarvis -gp