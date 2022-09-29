#!/bin/bash
cd ..
# release wannier90 src code
rm -rf tmp/wannier90
# copy templates
cp -rf templates/wannier90/3.1.0/data.wannier90.amd.cpu.config ./
# switch to config
./jarvis -use data.wannier90.amd.cpu.config
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r