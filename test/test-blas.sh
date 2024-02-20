#!/bin/bash
cd ..
# release blas src code
rm -rf tmp/blas-3.10.0
# copy templates
cp -rf templates/blas/3.10.0/data.blas.arm.bisheng.config ./
# switch to config
./jarvis -use data.blas.arm.bisheng.config
# download blas src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r