#!/bin/bash
# back to root
cd ..
# release qe src code
tar xzvf ./downloads/q-e-qe-6.4.1.tar.gz -C /tmp/
# copy workload
cp -rf ./workload/QE/qe-test /tmp
# copy templates
cp -rf ./templates/qe/6.4/data.qe.test.config ./
# switch to config
./jarvis -use data.qe.test.config
# install dependency
./jarvis -dp
# generate environment
./jarvis -e
# environment setup
source env.sh
# build
./jarvis -b
# run
./jarvis -r
# perf
./jarvis -p
# kperf
./jarvis -kp
# gpu nsysperf
./jarvis -gp