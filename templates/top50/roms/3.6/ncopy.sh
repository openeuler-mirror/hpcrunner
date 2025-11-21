#!/bin/sh
application=$1	#应用
param=${2:-""}  #应用参数
useCorePerNUMA=${3:-36}   #一个numa中使用多少个核
bind=${4:-1}	#绑定方式
nthread=${5:-1}  #如果mpirun里面没有 -x OMP_NUM_THREADS=n，需要在第5个参数指定。  
CSO_CORE_SHIFT=${6:-0}   # 偏移核数默认0

corePerNUMA=38
curpath=${PWD}

nrank=${OMPI_COMM_WORLD_LOCAL_SIZE:-1}
totalRank=${OMPI_COMM_WORLD_SIZE:-${nrank}}
rankId=${OMPI_COMM_WORLD_LOCAL_RANK:-0}
omp=${OMP_NUM_THREADS:-${nthread}}    #需在mpirun 命令中执行  -x OMP_NUM_THREADS=n  


if [ -f ${application} ]; then
	app_name=`basename ${application}`
	app_path=`dirname ${application}`
	cd ${app_path}
	if [ ! -f ${app_name}_{OMPI_COMM_WORLD_LOCAL_RANK} ]; then
		cp ${app_name} ${app_name}_${OMPI_COMM_WORLD_LOCAL_RANK}
	fi
	cd ${curpath}
fi

NUM_NUMAS=$[( totalRank * omp + useCorePerNUMA - 1) / useCorePerNUMA ]
rankPerNUMA=$(( totalRank / NUM_NUMAS ))

numaID=$(( rankId / rankPerNUMA ))
numaShift=$(( CSO_CORE_SHIFT / corePerNUMA ))
numaID=$(( numaShift + numaID ))

coreBeg=`expr ${numaID} \* ${corePerNUMA} + ${rankId} \% ${rankPerNUMA} \* $omp`
#方式一：顺序分配计算核（万能）
#方式二：剔除中间两个核(如：numa0  核18,19) （针对每个numa使用36核）
#方式三：每隔12个剔除一个核(如：numa0  核12,25)  （针对每个numa使用36核且线程数为12的约数）


case $bind in
1)
	coreBeg=$(( coreBeg + CSO_CORE_SHIFT ))
    coreEnd=$(( coreBeg + omp - 1 ))
    if [ $omp == 1  ]; then
        useCores="${coreBeg}"
    else
		useCores="${coreBeg}-${coreEnd}"
    fi
	;;
2)
	if [ $useCorePerNUMA -ne 36 ]; then
		echo "Please change the binding mode. This mode is not suitable."
		return 1
	fi
    coreBeg=$(( coreBeg + CSO_CORE_SHIFT ))
    coreEnd=$(( coreBeg + omp - 1 ))
    if [ $omp == 1  ]; then
        if [ $[ coreBeg % 38  ]   -gt 17 ]; then
		coreBeg=$[ coreBeg + 2 ]
        fi
        useCores="${coreBeg}"
    else
		if [ $((coreBeg % 38)) -gt 17 ] && [ $((coreEnd % 38)) -gt 17 ]; then
			coreBeg=$[ coreBeg + 2 ]
			coreEnd=$[ coreEnd + 2 ]
			useCores="${coreBeg}-${coreEnd}"
		elif [ $((coreBeg % 38)) -lt 17 ] && [ $((coreEnd % 38)) -gt 17 ]; then
			HALF_CORES=$(( omp / 2 ))
			coreBeg=$(( coreBeg + CSO_CORE_SHIFT ))
			coreEnd=$(( coreBeg + omp + 1 ))
			core_1=$(( coreBeg + HALF_CORES - 1 ))
			core_2=$(( coreEnd + 1 - HALF_CORES ))
			useCores="${coreBeg}-${core_1},${core_2}-${coreEnd}"
		else
			useCores="${coreBeg}-${coreEnd}"
		fi
    fi
	;;
3)
	if [ $useCorePerNUMA -ne 36 ]; then
		echo "Please change the binding mode. This mode is not suitable."
		return 1
	fi
	coreBeg=$(( coreBeg + CSO_CORE_SHIFT ))
    coreEnd=$(( coreBeg + omp - 1 ))
	if [ $omp == 1  ]; then
        if [ $[ coreBeg % 38  ]   -gt 23 ]; then
			coreBeg=$[ coreBeg + 2 ]
		elif [ $[ coreBeg % 38  ]   -gt 11 ]; then
			coreBeg=$[ coreBeg + 1 ]
        fi
        useCores="${coreBeg}"
    else
		if [ $((coreBeg % 38)) -gt 23 ] && [ $((coreEnd % 38)) -gt 23 ]; then
			coreBeg=$[ coreBeg + 2 ]
			coreEnd=$[ coreEnd + 2 ]
		elif [ $((coreBeg % 38)) -gt 11 ] && [ $((coreEnd % 38)) -gt 11 ]; then
			coreBeg=$[ coreBeg + 1 ]
			coreEnd=$[ coreEnd + 1 ]
			
		elif [ $((coreBeg % 38)) -lt 12 ] && [ $((coreEnd % 38)) -lt 12 ]; then
			coreBeg=$[ coreBeg + 0 ]
			coreEnd=$[ coreEnd + 0 ]
		else
			echo "Please change the binding mode. This mode is not suitable."
			return 1
		fi
		useCores="${coreBeg}-${coreEnd}"
	fi
	;;
	
*)
    coreBeg=$(( coreBeg + CSO_CORE_SHIFT ))
    coreEnd=$(( coreBeg + omp - 1 ))
    if [ $omp == 1  ]; then
        useCores="${coreBeg}"
    else
		useCores="${coreBeg}-${coreEnd}"
    fi
	;;
esac
if [ $app_name == namd3  ]; then
	numactl --all -m ${numaID} -C ${useCores}  ${application}_${rankId} +ppn $[ omp - 1 ] +commap ${coreBeg}-${coreEnd}:$omp +pemap $[ coreBeg + 1 ]-${coreEnd}:$omp.$[ omp - 1 ] $param
else
	numactl --all -p ${numaID} -C ${useCores} ${application}_${rankId} $param
fi
