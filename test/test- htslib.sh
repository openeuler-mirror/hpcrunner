#!/bin/bash
cd ..
# release curl src code
rm -rf tmp/htslib-1.15
# copy templates
cp -rf templates/htslib/1.15/data.htslib.arm.bisheng.config ./
# switch to config
./jarvis -use data.htslib.arm.bisheng.config
# download htslib src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r