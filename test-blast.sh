#!/bin/bash
cd ..
# release blast src code
rm -rf tmp/blast-2.13.0
# copy templates
cp -rf templates/blast/2.13.0/data.blast.arm.cpu.config ./
# switch to config
./jarvis -use data.blast.arm.cpu.config
# download blast src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r