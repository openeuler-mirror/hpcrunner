#!/bin/bash
cd ..
# release git src code
rm -rf tmp/git-2.35.1
# copy templates
cp -rf templates/git/2.35.1/data.git.arm.bisheng.config ./
# switch to config
./jarvis -use data.git.arm.bisheng.config
# download git src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r