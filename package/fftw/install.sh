#!/bin/bash
set -x
set -e
export UseGitee=0
export fftw_ver=3.3.10
../meta.sh $1
