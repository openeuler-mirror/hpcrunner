#!/bin/bash
cd ..
# release bowtie2 src code
rm -rf tmp/bowtie2-2.4.5
# copy templates
cp -rf templates/bowtie2/2.4.5/data.trinity.x86.cpu.config ./
# switch to config
./jarvis -use data.trinity.x86.cpu.config
# download bowtie2 src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r