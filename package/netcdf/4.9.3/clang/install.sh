#!/bin/bash
set -x
set -e
set -o posix
export netcdf_c_version='4.9.3'
export netcdf_f_version='4.6.2'
../../meta.sh $1