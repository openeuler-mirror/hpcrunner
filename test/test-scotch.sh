#!/bin/bash
cd ..
# release scotch src code
rm -rf tmp/scotch-v7.0.1
# copy templates
cp -rf templates/scotch/7.0.1/data.scotch.amd.cpu.config ./
# switch to config
./jarvis -use data.scotch.amd.cpu.config
# download scotch src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r