#!/bin/bash
cd ..
# release SU2 src code
rm -rf tmp/SU2-7.0.4
# copy templates
cp -rf templates/SU2/7.0.4/data.SU2.amd.cpu.config ./
# switch to config
./jarvis -use data.SU2.amd.cpu.config
# download SU2 src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r