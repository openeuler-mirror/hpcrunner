#!/bin/bash
cd ..
# release mg-cfd src code
rm -rf tmp/mg-cfd-1.1.0
# copy templates
cp -rf templates/mg-cfd/1.1.0/mg-cfd.arm.config ./
# switch to config
./jarvis -use mg-cfd.arm.config
# download mg-cfd src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r