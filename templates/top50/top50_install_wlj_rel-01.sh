#!/bin/bash
set -e
### 顺序非常重要，请勿随便修改
TIME=$(date +%Y%m%d%H%M%S)
SEQ=0
BCH=top50
cp templates/${BCH}/init.sh ./init.sh -ar
source ./init.sh
source package/common/libshell.sh
[ ! -d logs ]  && echo "Require logs dir" && exit 1
LOGDIR=logs/$(date +%Y%m%d)
mkdir -p ${LOGDIR}
mkdir -p ${LOGDIR}/bakcup
ls ${LOGDIR}/*.jlog > /dev/null 2>&1  && mv ${LOGDIR}/*.jlog ${LOGDIR}/bakcup/

function dotask()
{
	local TOKEN=$1
	local TIME=$2
	local LOGDIR=$3
	local LINE=$4
	echo_info "${TOKEN} [Line:${LINE}] Start ......"
	./jarvis -d | tee ${LOGDIR}/tee_${TOKEN}_download_${TIME}.jlog
	LOGFILE=${LOGDIR}/tee_${TOKEN}_dp_${TIME}.jlog
	./jarvis -dp | tee ${LOGFILE}
	res=${PIPESTATUS[0]}
	[ $res -ne 0 ] && echo_error "${TOKEN} [Line:${LINE}] FAILED,LOGFILE:${LOGFILE}" && exit 1
	LOGFILE=${LOGDIR}/tee_${TOKEN}_build_${TIME}.jlog
	./jarvis -b | tee ${LOGFILE}
	res=${PIPESTATUS[0]}
	[ $res -ne 0 ] && echo_error "${TOKEN} [Line:${LINE}] FAILED,LOGFILE:${LOGFILE}" && exit 1
	echo_info "${TOKEN} [Line:${LINE}] SUCCESS,LOGFILE:${LOGFILE}"	
	return 0
}

if false; then
########################################
#M 001
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_cmake
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/cmake/3.28.2/data.config  data.config -ar
	cp templates/${BCH}/cmake/3.28.2/dataconfig_patches ./ -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 002
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_hpckit_hmpi
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/hmpi/25.0.0/data.config  data.config -ar
	cp templates/${BCH}/hmpi/25.0.0/dataconfig_patches ./ -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 003
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_hpckit_bisheng
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/bisheng/25.0.0/data.config  data.config -ar
	cp templates/${BCH}/bisheng/25.0.0/dataconfig_patches ./ -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 004
EQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_fftw
echo "${TOKEN}"

if true; then
cp templates/${BCH}/fftw/3.3.8/bisheng/data.config  data.config -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 005
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_scalapack_pdgetrf
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/scalapack_pdgetrf/data.config  data.config -ar
	cp templates/${BCH}/scalapack_pdgetrf/dataconfig_patches ./ -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 006
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_boost
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/boost/1.72.0/bisheng/data.config  data.config -ar
	cp templates/${BCH}/boost/1.72.0/bisheng/dataconfig_patches ./ -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 007
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_kml_pdgetrf
echo "${TOKEN}"

if true; then
cp templates/${BCH}/kml/25.0.0/data.config  data.config -ar
cp templates/${BCH}/kml/25.0.0/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 008
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_lapack
echo "${TOKEN}"

if true; then
cp templates/${BCH}/lapack/bisheng/data.config ./data.config -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"


########################################
#M 009
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_blas
echo "${TOKEN}"

if true; then
cp templates/${BCH}/blas/3.8.0/bisheng/data.config ./data.config  -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 010
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_openblas
echo "${TOKEN}"

if true; then
cp templates/${BCH}/openblas/0.3.18/bisheng/data.config ./data.config -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"

########################################
#M 011
SEQ=$((10#$SEQ + 1))
SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
TOKEN=${SEQ}_bishengjdk
echo "${TOKEN}"

if true; then
	cp templates/${BCH}/bishengjdk/11.0.23/data.config  data.config -ar
	dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
fi
jarvis_next_step "$TOKEN"
fi ### test

stage=4002
if [ $stage -eq 4001 ]; then


########################################
#M 012

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_wannier_tools
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/wannier_tools/2.7.2/data.config data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"


	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_wannier
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/wannier/3.1.0/data.config data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_multiwfn
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/multiwfn/3.0.8/data.config data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_gulp
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/gulp/6.2/data.config data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_palabos
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/palabos/2.1/data.palabos.arm.cpu.config data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_cp2k
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/cp2k/7.1/data.CP2K.arm.cpu.config data.config -ar
		cp templates/${BCH}/cp2k/7.1/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_nemo
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/nemo/4.2.2/data.config  data.config -ar
		cp templates/${BCH}/nemo/4.2.2/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_namd
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/namd/3.0b/data.namd.arm.cpu.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_ww3
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/ww3/6.07.1/bisheng/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_openfoam
	echo "${TOKEN}"

	if false; then
		cp templates/${BCH}/openfoa/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	echo "B test FAILED"
	jarvis_next_step "$TOKEN"


	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_roms
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/roms/3.6/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_relion
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/relion/4.0.1/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi

	jarvis_next_step "$TOKEN"



########################################
#M 012

########################################
#M 012
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_specfem3d
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/specfem3d/4.1.1/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 012
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_wrf
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/wrf/4.6/bisheng/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 013

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_camx
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/camx/7.31/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 014
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_vasp
	echo "${TOKEN}"
	# test failed
	if true; then
		cp templates/${BCH}/vasp/6.3.2/data.config data.config -ar
		cp templates/${BCH}/vasp/6.3.2/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 015
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_qe
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/qe/7.3-bisheng4.2.0-hmpi25.0.0/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 016
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_cesm
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/cesm/1.2.2/bisheng4.2.2/data.config  data.config -ar
		cp templates/${BCH}/cesm/1.2.2/bisheng4.2.2/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 017
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_gromacs
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/gromacs/2024.2/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

########################################
#M 018
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_lammps
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/lammps/2023.8.2/data.config  data.config -ar
		cp templates/${BCH}/lammps/2023.8.2/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

fi #4001

### check ok
stage=5002
if [ $stage -eq 5001 ]; then
########################################
#M 018

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_bwa
	echo "${TOKEN}"
	#BCH=top50
	if true; then
		cp templates/${BCH}/bwa/0.7.17/data.config  data.config -ar
		cp templates/${BCH}/bwa/0.7.17/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_samtools
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/samtools/1.10/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"


	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_gatk
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/gatk/4.0.0.0/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	exit 1	
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_augustus
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/augustus/3.3.3/data.config  data.config -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"
fi

# for gcc hpckit  raw tool
stage=9001
if [ $stage -eq 9001 ]; then
########################################
#M 019

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_ncl
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/ncl/6.6.2/data.ncl-gcc.arm.cpu.config  data.config -ar
		cp templates/${BCH}/ncl/6.6.2/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_nco
	echo "${TOKEN}"

	if true; then
		cp -Lf templates/${BCH}/nco/5.1.4/data.NCO.arm.cpu.config  ./data.config
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_cdo
	echo "${TOKEN}"

	if true; then
		cp -Lf templates/${BCH}/cdo/1.9.8/cdo.arm.data.config  ./data.config
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_gsl
	echo "${TOKEN}"

	if true; then
		cp -Lf templates/${BCH}/gsl/12.3.1/data.gsl.arm.cpu.config  ./data.config
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_ncview
	echo "${TOKEN}"

	if true; then
		cp -Lf templates/${BCH}/ncview/2.1.5/data.ncview.arm.cpu.config  ./data.config
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"
	
########################################
#M 020

fi #9001


### anacon and python
stage=1001
if [ $stage -eq 1001 ]; then
########################################
#M 021

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_chaste
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/chaste/2019.1/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi

	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_Anaconda3
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/Anaconda3/2023.3/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi

	jarvis_next_step "$TOKEN"

	
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_jax
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/jax/0.4.30-gcc10.3.1/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi

	jarvis_next_step "$TOKEN"

	
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_xla
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/xla/test_653994136-bisheng4.2.0/data.config  data.config -ar
		cp templates/${BCH}/xla/test_653994136-bisheng4.2.0/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"
	
	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_vaspkit
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/vaspkit/0.52/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_phono3py
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/phono3py/3.2.0/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_phonopy
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/phonopy/2.25.0/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"


	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_phono3py
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/phono3py/3.2.0/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"


	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_pytorch
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/pytorch/2.5.1/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_tensorflow
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/tensorflow/2.13.0/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	exit 1

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_tvm
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/apache-tvm/0.16.0/bisheng/data.config ./ -ar
		cp templates/${BCH}/apache-tvm/0.16.0/bisheng/dataconfig_patches ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	SEQ=$((10#$SEQ + 1))
	SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
	TOKEN=${SEQ}_deepmdkit
	echo "${TOKEN}"

	if true; then
		cp templates/${BCH}/deepmdkit/3.0.1/data.config ./ -ar
		dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
	fi
	jarvis_next_step "$TOKEN"

	exit 1
########################################
#M 022
fi #1001

set +e
