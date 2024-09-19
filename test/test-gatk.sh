#!/bin/bash
cd ..
# release gatk src code
rm -rf tmp/gatk-4.0.0.0
# copy templates
cp -rf templates/gatk/4.0.0.0/data.gatk.arm.cpu.config ./
# switch to config
./jarvis -use data.gatk.arm.cpu.config
# download gatk src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r