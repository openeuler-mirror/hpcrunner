#!/bin/bash
set -x
set -e
set -o posix
export netcdf_c_version='4.8.1'
export netcdf_f_version='4.5.4'
../../meta.sh $1