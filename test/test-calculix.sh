#!/bin/bash
cd ..
# release calculix src code
rm -rf tmp/calculix-2.19.0
# copy templates
cp -rf templates/calculix/2.19.0/data.calculix.arm.cpu.config ./
# switch to config
./jarvis -use data.calculix.arm.cpu.config
# download calculix src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r