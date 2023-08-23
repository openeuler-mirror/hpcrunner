#!/bin/bash
cd ..
# release jasper src code
rm -rf tmp/JASPER_1.900.2.tar.gz
# copy templates
cp -rf templates/jasper/1.900.2/data.jasper.arm.cpu.config ./
# switch to config
./jarvis -use data.jasper.arm.cpu.config
# download jasper src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r
