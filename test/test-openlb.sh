#!/bin/bash
cd ..
# release openlb src code
rm -rf tmp/olb-1.4r0
tar xzvf ./downloads/olb-1.4r0.tar.gz -C tmp/
# copy templates
cp -rf templates/openlb/1.4/data.openlb.amd.cpu.config ./
# switch to config
./jarvis -use data.openlb.amd.cpu.config
# install dependency
./jarvis -dp
# build
./jarvis -b
