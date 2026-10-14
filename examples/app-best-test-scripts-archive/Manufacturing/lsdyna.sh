#!/bin/bash

install_dir=/share/install/lsdyna
case_dir=/share/cases/
lic_dir=/share/install/license9.2
intel_dir=/share/install/oneapi
case_name="test.k"
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np_per_node=124
np=$(($nodes*$np_per_node))

run_flag=""
if [ x"$(arch)" == xaarch64 ];then 
    run_flag="exagear --"
fi

gen_hostlist()
{
    if [ ! x"$(arch)" == xaarch64 ];then 
        echo "[ERROR] please run on aarch64"
        exit 1
    fi
    if ! grep -q "LSDYNA" "/opt/exagear/etc/exagear.conf.d/lsdyna.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/lsdyna.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "LSDYNA" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
fi
EOF
        while read -r host ; do
            [ -z "$host" ] && continue
            [ "$host" = "$(hostname -s)" ] && { continue; }
            scp /opt/exagear/etc/exagear.conf.d/lsdyna.conf "$host":/opt/exagear/etc/exagear.conf.d/lsdyna.conf 
        done < ${hostfile}
    fi
    
}

run()
{
    gen_hostlist
    cd ${case_dir}
    export EXAGEAR_APP_NAME="LSDYNA"
    source ${intel_dir}/setvars.sh
    export ANSYSLIC_DIR=${lic_dir}
    export LSTC_LICENSE=ANSYS
    unset LSTC_FILE
    (time -p ${run_flag} mpirun -genv I_MPI_FABRICS=shm:ofi -genv EXAGEAR_APP_NAME=LSDYNA -genv ANSYSLIC_DIR=${lic_dir} -genv LSTC_LICENSE=ANSYS -n ${np} -ppn ${np_per_node} -machinefile ${hostfile} ${install_dir}/ls-dyna_mpp_s_R9_3_1_x64_centos65_ifort131_sse2_intelmpi-2018 i=${case_name} memory=1600M memory2=600M) 2>&1 |tee ${log_file}
}
run