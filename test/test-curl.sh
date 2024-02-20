#!/bin/bash
cd ..
# release curl src code
rm -rf tmp/curl-7.82.0
# copy templates
cp -rf templates/curl/7.82.0/data.curl.arm.cpu.config ./
# switch to config
./jarvis -use data.curl.arm.cpu.config
# download curl src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r