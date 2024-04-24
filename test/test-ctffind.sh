#!/bin/bash
cd ..
# release ctffind src code
rm -rf tmp/ctffind-4.1.14
# copy templates
cp -rf templates/ctffind/4.1.14/data.ctffind.arm.cpu.config ./
# switch to config
./jarvis -use data.ctffind.arm.cpu.config
# download ctffind src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r