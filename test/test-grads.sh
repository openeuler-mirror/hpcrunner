#!/bin/bash
cd ..
# release grads src code
rm -rf tmp/grads-2.0.a4
# copy templates
cp -rf templates/grads/2.0.a4/data.grads.arm.cpu.config ./
# switch to config
./jarvis -use data.grads.arm.cpu.config
# download grads src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r