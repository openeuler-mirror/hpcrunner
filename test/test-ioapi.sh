#!/bin/bash
cd ..
# release ioapi src code
rm -rf tmp/ioapi-3.2
# copy templates
cp -rf templates/ioapi/3.2/data.ioapi_clang.arm.cpu.config ./
# switch to config
./jarvis -use data.ioapi_clang.arm.cpu.config
# download ioapi src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r