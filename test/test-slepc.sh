#!/bin/bash
cd ..
# release slepc src code
rm -rf tmp/slepc-3.18.1.tar.gz
# copy templates
cp -rf templates/slepc/3.18.1/data.slepc.amd.cpu.config ./
# switch to config
./jarvis -use data.slepc.amd.cpu.config
# download slepc src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r