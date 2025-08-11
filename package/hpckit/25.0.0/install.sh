#!/bin/bash
set -e
export hpckit_ver="25.0.0"
../meta.sh $1

ln -s $1/HPCKit/${hpckit_ver}/modulefiles $1/../../../modulefiles/hpckit${hpckit_ver}

for hmpi_file in `find -L $1/HPCKit/${hpckit_ver}/modulefiles -name hmpi`
do
    echo -e "\nsetenv CC mpicc \nsetenv CXX mpicxx \nsetenv FC mpifort \nsetenv F77 mpifort \nsetenv F90 mpifort " >> ${hmpi_file}
done