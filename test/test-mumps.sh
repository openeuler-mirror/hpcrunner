#!/bin/bash
cd ..
# release mumps src code
rm -rf tmp/MUMPS_5.1.2.tar.gz
# copy templates
cp -rf templates/mumps/5.1.2/data.mumps.amd.cpu.config ./
# switch to config
./jarvis -use data.mumps.amd.cpu.config
# download mumps src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r