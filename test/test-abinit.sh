#!/bin/bash
cd ..
# release mg-cfd src code
rm -rf tmp/abinit-8.10.3.tar.gz
# copy templates
cp -rf templates/abinit/8.10.3/data.abinit.arm.gpu.config ./
# switch to config
./jarvis -use data.abinit.arm.gpu.config
# download abinit src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r