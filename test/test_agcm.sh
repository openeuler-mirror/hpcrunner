#!/bin/bash
cd ..
# release curl src code
rm -rf tmp/htslib-1.15
# copy templates
cp -rf templates/agcm/4.0/agcm.arm.cpu.config ./
# switch to config
./jarvis -use agcm.arm.cpu.config
# download agcm src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r