#!/bin/bash

install_dir=/share/install/bwa/
case_dir=/share/cases/
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np=128

load_path()
{
    module use /share/install/HPCKit/latest/modulefiles
    module load bisheng/compiler5.1.0.2/bishengmodule
}
run()
{
    cd ${case_dir}
    load_path
    ${install_dir}/bin/bwa mem -M -t ${np} hs38DH.fasta ERR1044518_1.fastq ERR1044518_2.fastq > bwa.sam  2>${log_file}
}
run