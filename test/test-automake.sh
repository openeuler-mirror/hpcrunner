#!/bin/bash
cd ..
# release automake src code
rm -rf tmp/automake-1.16.5
# copy templates
cp -rf templates/automake/1.16.5/data.automake.arm.bisheng.config ./
# switch to config
./jarvis -use data.automake.arm.bisheng.config
# download automake src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r