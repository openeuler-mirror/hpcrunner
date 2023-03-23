#!/bin/bash
cd ..
# release petsc src code
rm -rf tmp/petsc-3.18.1.tar.gz
# copy templates
cp -rf templates/petsc/3.18.1/data.petsc.amd.cpu.config ./
# switch to config
./jarvis -use data.petsc.amd.cpu.config
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r