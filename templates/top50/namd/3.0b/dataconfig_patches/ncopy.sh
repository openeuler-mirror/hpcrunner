#!/bin/bash
curpath=$(readlink -f ./)

application=$1	#应用
param=${2:-""}  #应用参数

if [ -f ${application} ]; then
	app_name=`basename ${application}`
	app_path=`dirname ${application}`
	cd ${app_path}
	if [ ! -f ${app_name}_{OMPI_COMM_WORLD_LOCAL_RANK} ]; then
		cp ${app_name} ${app_name}_${OMPI_COMM_WORLD_LOCAL_RANK}
	fi
	cd ${curpath}
fi

COREOFFSET=0
numaId=`expr ${OMPI_COMM_WORLD_LOCAL_RANK} / 2`
numaIdIdx=`expr ${OMPI_COMM_WORLD_LOCAL_RANK} % 2`
coreId=`expr ${numaId} \* 38 + ${numaIdIdx} \* 19 + ${COREOFFSET}`
coreIdOne=`expr ${coreId} + 1`
coreIdMax=`expr ${coreId} + 18`
# numaIdFlat=`expr ${numaId} + 16`
 numactl --all -m ${numaId} -C ${coreId}-${coreIdMax}  ${application}_${OMPI_COMM_WORLD_LOCAL_RANK} +ppn 18 +commap ${coreId}-${coreIdMax}:19 +pemap ${coreIdOne}-${coreIdMax}:19.18 ${param}
