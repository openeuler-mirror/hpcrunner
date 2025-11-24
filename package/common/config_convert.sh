#!/bin/bash
#set -x 
set -e
echo "PARAM:$@"
args=("$@")
[ ! -x config_def.sh ] && echo "WARNING: require config_def.sh " && exit 0
source ./config_def.sh
#MYCVER=hpckit25.1.0.SPC001-bisheng4.2.0.2.B002
#MYHVER=hmpi25.1.0.SPC001
for item in "${args[@]}"
do
	FSRC="$item"
	[ ! -f "${FSRC}" ] && echo "ERROR: Invalid input file!!!" && exit 1
	if grep -RHn --color -q "%#MYKBSVER#%" "${FSRC}" ; then
		[ -z ${MYKBSVER} ] && echo "ERROR: Invalid MYKBSVER:${MYKBSVER}" && exit 1
	fi
	if grep -RHn --color -q "%#MYKMPIVER#%" "${FSRC}" ; then
		[ -z ${MYKMPIVER} ] && echo "ERROR: Invalid MYKMPIVER:${MYKMPIVER}" && exit 1
	fi
	
	if grep -RHn --color -q "%#MYKGCCVER#%" "${FSRC}" ; then
		[ -z ${MYKGCCVER} ] && echo "ERROR: Invalid MYKMPIVER:${MYKGCCVER}" && exit 1
	fi
done


for item in "${args[@]}"
do
	FSRC="$item"
	[ ! -f "${FSRC}" ] && echo "ERROR: Invalid input file!!!" && exit 1
	if grep -RHn --color -q "%#MYKBSVER#%" "${FSRC}" ; then
		#sed -n "s/%#MYKBSVER#%/${MYKBSVER}/gp" "${FSRC}"
		sed -i "s/%#MYKBSVER#%/${MYKBSVER}/g" "${FSRC}"
	fi
	if grep -RHn --color -q "%#MYKMPIVER#%" "${FSRC}" ; then
		#sed -n "s/%#MYKMPIVER#%/${MYKMPIVER}/gp" "${FSRC}"
		sed -i "s/%#MYKMPIVER#%/${MYKMPIVER}/g" "${FSRC}"
	fi
	
	if grep -RHn --color -q  "%#MYKGCCVER#%" "${FSRC}" ; then
		#sed -n "s/%#MYKGCCVER#%/${MYKGCCVER}/gp" "${FSRC}"
		sed -i "s/%#MYKGCCVER#%/${MYKGCCVER}/g" "${FSRC}"
	fi
done

exit 0

