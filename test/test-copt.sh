#!/bin/bash
cd ..
# release copt src code
rm -rf tmp/copt-6.5
# copy templates
cp -rf templates/copt/6.5/copt.arm.config ./
# switch to config
./jarvis -use copt.arm.config
# download copt src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r