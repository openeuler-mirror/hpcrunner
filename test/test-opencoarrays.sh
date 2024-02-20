#!/bin/bash
cd ..
# release OpenCoarrays src code
rm -rf tmp/OpenCoarrays-2.10.1.tar.gz
# copy templates
cp -rf templates/OpenCoarrays/2.10.1/data.openCoarrays.amd.cpu.config ./
# switch to config
./jarvis -use data.openCoarrays.amd.cpu.config
# download OpenCoarrays src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r