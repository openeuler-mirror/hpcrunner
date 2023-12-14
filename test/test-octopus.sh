#!/bin/bash
cd ..
# release octopus src code
rm -rf tmp/octopus-10.3
# copy templates
cp -rf templates/octopus/10.3/data.octopus.arm.kpgcc.cpu.config ./
# switch to config
./jarvis -use data.octopus.arm.kpgcc.cpu.config
# download octopus src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r