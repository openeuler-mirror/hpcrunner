#!/bin/bash
cd ..
# release cfftw src code
rm -rf tmp/fftw-3.38
# copy templates
cp -rf templates/fftw/3.38/data.fftw.arm.cpu.config ./
# switch to config
./jarvis -use data.fftw.arm.cpu.config
# download fftw src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r