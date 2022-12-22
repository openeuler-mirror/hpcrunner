#!/bin/bash
cd ..
# release imb src code
rm -rf tmp/IMB-v2021.3
# copy templates
cp -rf templates/imb/2021.3/data.imb.amd.cpu.config ./
# switch to config
./jarvis -use data.imb.amd.cpu.config
# download imb src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r
