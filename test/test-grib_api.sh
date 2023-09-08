#!/bin/bash
cd ..
# release grib_api src code
rm -rf tmp/grib_api-1.21.0
# copy templates
cp -rf templates/grib_api/1.21.0/data.grib_api.arm.cpu.config ./
# switch to config
./jarvis -use data.grib_api.arm.cpu.config
# download grib_api src code
./jarvis -d
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r