#!/bin/bash
cd ..
# release bedtools src code
rm -rf tmp/bedtools-2.28.0
# copy templates
cp -rf templates/bedtools/2.28.0/data.bedtools.arm.cpu.config ./
# switch to config
./jarvis -use data.bedtools.arm.cpu.config
# download bedtools src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r