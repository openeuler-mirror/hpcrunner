#!/bin/bash
cd ..
# release boost src code
rm -rf tmp/boost-1.72.0
# copy templates
cp -rf templates/boost/1.72.0/data.boost.arm.cpu.config ./
# switch to config
./jarvis -use data.boost.arm.cpu.config
# download boost src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r