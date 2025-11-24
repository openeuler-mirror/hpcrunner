#!/bin/bash
set -e
### 顺序非常重要，请勿随便修改
TIME=$(date +%Y%m%d%H%M%S)
SEQ=0
BCH=top50
#cp templates/${BCH}/init.sh ./init.sh -ar
source ./init.sh
source package/common/libshell.sh
cp package/common/config_convert.sh . -ar
cp templates/${BCH}/config_def_2025.1.0.SPC001.sh config_def.sh -ar
chmod 755 config_def.sh config_convert.sh

read -p $'\033[1;32m 安装根路径为：'"${JARVIS_SOFT_ROOT}"'？(yes/no): '$'\033[0m' myanswer
[ "$myanswer" != "yes" ] && exit 1
[ ! -d logs ]  && echo "Require logs dir" && exit 1
LOGDIR=logs/$(date +%Y%m%d)
mkdir -p ${LOGDIR}
mkdir -p ${LOGDIR}/backup
ls ${LOGDIR}/*.jlog > /dev/null 2>&1  && mv ${LOGDIR}/*.jlog ${LOGDIR}/backup/

# add item (true f_xxx  1 yyy), and define function f_xxx
CASE_ITEMS=(
#1					#2					#3					#4 				
T "f_cmake" 1 "cmake"			T "f_hmpi" 1 "hmpi"			T "f_bisheng" 1 "bisheng"		T "f_fftw" 1 "fftw"
T "f_scalapack" 1 "scalapack"		T "f_boost" 1 "boost"			T "f_kml" 1 "kml"			T "f_lapack" 1 "lapack"
###															#<-- stage=4001
T "f_blas" 1 "blas"			T "f_openblas" 1 "openblas"		T "f_jdk" 1 "jdk"			T "f_wanniertools" 1 "wanniertools"
T "f_wannier" 1 "wannier"		T "f_multiwfn" 1 "multiwfn"		T "f_gulp" 1 "gulp"			T "f_palabos" 1 "palabos"	
T "f_cp2k" 1 "cp2k"			T "f_nemo" 1 "nemo"			T "f_namd" 1 "namd"			T "f_ww3" 1 "ww3"
T "f_openfoa" 1 "openfoa"		T "f_roms" 1 "roms"			T "f_relion" 1 "relion"			T "f_specfem3d" 1 "specfem3d"
T "f_wrf" 1 "wrf"			T "f_camx" 1 "camx"			T "f_vasp" 1 "vasp"			T "f_qe" 1 "qe"
###															#	 stage=4001 -->
T "f_cesm122" 1 "cesm122"		T "f_cesm222" 1 "cesm222"		T "f_gromacs" 1 "gromacs"		T "f_lammps" 1 "lammps"
#<-- stage=5002														stage=5002 -->
T "f_bwa" 1 "bwa"			T "f_samtools" 1 "samtools"		T "f_gatk" 1 "gatk"			T "f_augustus" 1 "augustus"
#<-- stage=9001
T "f_ncl" 1 "ncl"			T "f_nco" 1 "nco"			T "f_cdo" 1 "cdo"			T "f_gsl" 1 "gsl"
#	 stage=9001 -->			#<-- stage=1001,python&conda3 serials
T "f_ncview" 1 "ncview"			T "f_chaste" 1 "chaste"			T "f_conda3" 1 "conda3"			T "f_jax" 1 "jax"
T "f_alphafold2" 1 "alphafold2"		T "f_xla" 1 "xla"			T "f_vaspkit" 1 "vaspkit"		T "f_phono3py" 1 "phono3py"
T "f_phonopy" 1 "phonopy"		T "f_pytorch" 1 "pytorch"		T "f_tf" 1 "tensorflow"			T "f_tvm" 1 "tvm"
#	 stage=1001 -->
T "f_deepmdkit" 1 "deepmdkit"
)
# test ok 20251030 by wlj: cmake, hmpi, bisheng, fftw, scalapack,boost,kml,lapack,blas,openblas,jdk,f_wanniertools,wannier
# test ok 20251031 by cc:gatk,roms,chaste,specfem3d,nemo,relion,phonopy,alphafold2
callback_entry() {
    local callback=$1
    local d1=$2
    local d2=$3
    local d3=$4

    # 调用回调函数
    $callback "$d1" "$d2" "$d3" "$d4" "$d5"
}

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

function f_cmake()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/cmake/3.28.2/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/cmake/3.28.2/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

########################################
#M 002
#20251029 test ok by wanlijun

function f_hmpi()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/hmpi/25.0.0/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/hmpi/25.0.0/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_bisheng()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/bisheng/25.0.0/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/bisheng/25.0.0/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_fftw()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/fftw/3.3.8/bisheng/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_scalapack()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/scalapack_pdgetrf/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/scalapack_pdgetrf/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

########################################
#M 006
#20251029 test ok by wanlijun
function f_boost()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/boost/1.72.0/bisheng/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/boost/1.72.0/bisheng/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

########################################
#M 007
#20251029 test ok by wanlijun
function f_kml()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/kml/25.0.0/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/kml/25.0.0/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

########################################
#M 008
#20251029 test ok by wanlijun
function f_lapack()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/lapack/bisheng/data.config ./data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_blas()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/blas/3.8.0/bisheng/data.config ./data.config  -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_openblas()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/openblas/0.3.18/bisheng/data.config ./data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_jdk()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/bishengjdk/11.0.23/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_wanniertools()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/wannier_tools/2.7.2/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_wannier()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/wannier/3.1.0/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_multiwfn()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/multiwfn/3.8/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_gulp()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/gulp/6.2/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_palabos()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/palabos/2.1/data.palabos.arm.cpu.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_cp2k()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/cp2k/7.1/data.CP2K.arm.cpu.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_nemo()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/nemo/4.2.2/data.opt.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_namd()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/namd/3.0b/data.namd.arm.cpu.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_ww3()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
echo_error "${TOKEN} [Line:${LINE}] Please add task here!!!" && exit 1
return 0
}

function f_openfoa()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
echo_error "${TOKEN} [Line:${LINE}] Please add task here!!!" && exit 1
return 0
}

function f_roms()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/roms/3.6/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_relion()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/relion/4.0.1/data.opt.config  data.config  -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_specfem3d()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/specfem3d/4.1.1/data.binary.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_wrf()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/wrf/4.6/bisheng/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_camx()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/camx/7.31/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_vasp()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/vasp/6.3.2/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_qe()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/qe/7.3-bisheng4.2.0-hmpi25.0.0/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_cesm122()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/cesm/1.2.2/bisheng4.2.2/data_opt.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/cesm/1.2.2/bisheng4.2.2/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_cesm222()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/cesm/2.2.2/bisheng4.2.2/data_opt.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/cesm/2.2.2/bisheng4.2.2/dataconfig_patches ./ -ar
./config_convert.sh  ./dataconfig_patches/cesm/2.2.2/scripts/mycesm_build.sh
./config_convert.sh  ./dataconfig_patches/cesm/2.2.2/scripts/mycesm_run.sh
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_gromacs()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/gromacs/2023.3/gromacs.2023.3.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_lammps()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"

cp templates/${BCH}/lammps/2023.8.2/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}


function f_bwa()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/bwa/0.7.17/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}
	
function f_samtools()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"

return 0
}

function f_gatk()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/gatk/4.0.0.0/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}
	
function f_augustus()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/augustus/3.3.3/data.config  data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_ncl()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/ncl/6.6.2/data.ncl-gcc.arm.cpu.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/ncl/6.6.2/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_nco()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp -Lf templates/${BCH}/nco/5.1.4/data.NCO.arm.cpu.config  ./data.config
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_cdo()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"	
cp -Lf templates/${BCH}/cdo/1.9.8/cdo.arm.data.config  ./data.config
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_gsl()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"	
cp -Lf templates/${BCH}/gsl/12.3.1/data.gsl.arm.cpu.config  ./data.config
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_ncview()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp -Lf templates/${BCH}/ncview/2.1.5/data.ncview.arm.cpu.config  ./data.config
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_chaste()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/chaste/2019.1/data.binary.config ./data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_conda3()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/Anaconda3/2023.3/data.config ./ -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_jax()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/jax/0.4.30-gcc10.3.1/data.config ./ -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_alphafold2()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"

cp templates/${BCH}/alphafold/2/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}	

function f_xla()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/xla/test_653994136-bisheng4.2.0/data.config  data.config -ar
./config_convert.sh data.config
cp templates/${BCH}/xla/test_653994136-bisheng4.2.0/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_vaspkit()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/vaspkit/0.52/data.config ./ -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_phono3py()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/phono3py/3.2.0/data.config data.config  -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}	

function f_phonopy()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/phonopy/2.25.0/data.config data.config  -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}	

function f_pytorch()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
echo_error "${TOKEN} [Line:${LINE}] Please add task here!!!" && exit 1
return 0
}	

function f_tf()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/tensorflow/2.13.0/data.config ./ -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

function f_tvm()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/apache-tvm/0.16.0/bisheng/data.config ./ -ar
./config_convert.sh data.config
cp templates/${BCH}/apache-tvm/0.16.0/bisheng/dataconfig_patches ./ -ar
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}
	
function f_deepmdkit()
{
local TOKEN=$1
local TIME=$2
local LOGDIR=$3
echo "${TOKEN}"
cp templates/${BCH}/deepmdkit/3.0.1/data.config data.config -ar
./config_convert.sh data.config
dotask ${TOKEN} ${TIME} ${LOGDIR} ${LINENO}
return 0
}

####============main=========================
for ((i=0; i<${#CASE_ITEMS[@]}; i+=4));
do
   SEQ=$((10#$SEQ + 1))
   SEQ=$(echo $SEQ | awk '{printf "%08d", $1}')
   TOKEN="${SEQ}_${CASE_ITEMS[$((i+3))]}"
   if [ "${CASE_ITEMS[i]}" == "I" ]; then
	   echo_info "Interrupt routine: ${TOKEN} [Line:${LINE}]"
	   exit 0
   fi
   if [ "${CASE_ITEMS[i]}" == "T" ]; then
        callback_entry ${CASE_ITEMS[$((i+1))]} ${TOKEN} ${TIME} ${LOGDIR}
	jarvis_next_step "${SEQ}_${CASE_ITEMS[$((i+3))]}"
   else
	echo_info "${TOKEN} [Line:${LINENO}] Igore !!!"
   fi
done
