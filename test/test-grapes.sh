#!/bin/bash
cd ..
# release grapes src code
rm -rf tmp/grapes-3.0.2
# copy templates
cp -rf templates/grapes/3.0.2/grapes.x86.cpu.config ./
# switch to config
./jarvis -use grapes.x86.cpu.config
# download grapes src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r