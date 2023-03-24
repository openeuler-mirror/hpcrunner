#!/bin/bash
cd ..
# release stream src code
rm -rf tmp/stream-1.8
# copy templates
cp -rf templates/stream/1.8/data.stream.x86.cpu.config ./
# switch to config
./jarvis -use data.stream.x86.cpu.config
# download stream src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r