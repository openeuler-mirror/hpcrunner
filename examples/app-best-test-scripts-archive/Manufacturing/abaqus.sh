#!/bin/bash

install_dir=/share/install/abaqus
case_dir=/share/cases/
lic_dir=/share/install/SolidSQUAD_License_Servers
case_name="hj-test1.inp"
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np_per_node=124
threads_num=8
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
    while read LINE
    do
       array=(${LINE//././})
       if [ -n "${array[0]}" ]; then
          hostlist=$hostlist[\'${array[0]}\',${np_per_node}],
       fi
    done < ${hostfile}
    hostlist="[${hostlist%?}]"
    if ! grep -q "ABAQUS" "/opt/exagear/etc/exagear.conf.d/abaqus.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/abaqus.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "ABAQUS" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
    EXAGEAR_PT_CONFIG=/share/install/abaqus/pt.conf
fi
EOF
        while read -r host ; do
            [ -z "$host" ] && continue
            [ "$host" = "$(hostname -s)" ] && { continue; }
            scp /opt/exagear/etc/exagear.conf.d/abaqus.conf "$host":/opt/exagear/etc/exagear.conf.d/abaqus.conf 
        done < ${hostfile}
    fi
    
}

lic_start()
{
    lic_lines=$(lsof -i:27800 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "abaqus's license not found. Starting license server..."
        ${run_flag} bash ${lic_dir}/install_or_update.sh
        #${run_flag} ${lic_dir}/Bin/lmgrd -c ${lic_dir}/Licenses/lmgrd_SSQ.lic -l ${lic_dir}/Logs/lmgrd.log
    fi
    sleep 10
    lic_lines=$(lsof -i:27800 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "abaqus's license server start failed. Exiting..."
        exit 2
    fi
}

run()
{
    gen_hostlist
    cd ${case_dir}
    cat > "abaqus_v6.env" << EOF
mp_host_list=$hostlist
mp_mode=MPI
mp_mpi_implementation=IMPI
EOF
    #替换MPI修改abaqus_v6.env添加以下内容
    #mp_mpirun_path={IMPI:'$install_path/inc/linux_a64/code/bin/SMAExternal/impi/intel64/bin/mpirun'}
    export LM_LICENSE_FILE=27800@`hostname`
    export EXAGEAR_APP_NAME="ABAQUS"
    #export I_MPI_FABRICS=shm:tcp
    (time -p ${run_flag} ${install_dir}/commands/abq cpus=$np job=test1 input=${case_name} scratch=./ int threads_per_mpi_process=${threads_num}) 2>&1 |tee ${log_file}
}
lic_start
run