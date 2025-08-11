#!/bin/bash
set -x
set -e

yum install --downloadonly --downloaddir=./downloads/fftw3-devel  fftw3-devel -y
yum localinstall ./downloads/fftw3-devel/*.rpm -y


