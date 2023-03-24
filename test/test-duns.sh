#!/bin/bash
cd ..
# release duns src code
rm -rf tmp/duns-2.7.1
# copy templates
cp -rf templates/duns/2.7.1/data.duns.x86.cpu.config ./
# switch to config
./jarvis -use data.duns.x86.cpu.config
# download duns src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r