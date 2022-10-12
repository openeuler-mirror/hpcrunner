#!/bin/bash
cd ..
# release bowtie2 src code
rm -rf tmp/trinityrnaseq-v2.14.0.FULL_with_extendedTestData
# copy templates
cp -rf templates/trinity/2.14.0/data.trinity.x86.cpu.config ./
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