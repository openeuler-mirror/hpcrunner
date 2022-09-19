#!/bin/bash
cd ..
# release qmcpack src code
rm -rf tmp/v3.13.0.tar.gz
# copy templates
cp -rf templates/qmcpack/3.13.0/data.qmcpack.amd.cpu.config ./
# switch to config
./jarvis -use data.qmcpack.amd.cpu.config
# download qmcpack src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r
