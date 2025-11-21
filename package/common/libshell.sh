function backup_yum_system()
{
	if [ "${JARVIS_SYSTEM_ROOT}" != "${JARVIS_YUM_SYSTEM}" ] && [ ! -z "${JARVIS_YUM_SYSTEM}" ]; then
		for i in $(ls "${JARVIS_YUM_SYSTEM}"/etc/yum.repos.d/*.repo); do mv "${i}" "${i}".xyyx;done
	fi	
}

function get_yum_opt()
{
	if [ -f "${JARVIS_YUM_CONFIG}" ]; then
		echo "--config=${JARVIS_YUM_CONFIG} --disablerepo=\"*\" --enablerepo=\"JARVIS_SYS_CDROM\""
	else 
		echo ""
	fi	
}

function restore_yum_system()
{
	if [ "${JARVIS_SYSTEM_ROOT}" != "${JARVIS_YUM_SYSTEM}" ] && [ ! -z "${JARVIS_YUM_SYSTEM}" ]; then
		for i in $(ls "${JARVIS_YUM_SYSTEM}"/etc/yum.repos.d/*.repo.xyyx); do  mv "${i}" ${i%.xyyx};done
	fi
}

function yum_install_local_rpms()
{
#	if  yum  list installed | grep -q "${package}" ; then
#		return 0
#	fi
	yum  install $@ -y
	return 0
}


function yum_install_system_rpms()
{

#	if yum --installroot="${JARVIS_YUM_SYSTEM}" list installed | grep -q perl-CPAN-Meta.noarch ; then
#               echo yes
#       fi
	backup_yum_system
	yum --installroot="${JARVIS_YUM_SYSTEM}" install $@ -y $(get_yum_opt)
	restore_yum_system
	return 0
}


function echo_error()
{
        local RED='\e[1;31m'
        local GREEN='\e[1;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[1;34m'
        local RESET='\e[0m'

# 使用函数封装
        echo -e "${RED}[ERROR] ${1}${RESET}"; 
}

function echo_success()
{
        local RED='\e[1;31m'
        local GREEN='\e[1;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[1;34m'
        local RESET='\e[0m'

	echo -e "${GREEN}[SUCCESS] ${1}${RESET}"
}

function echo_warning()
{
        local RED='\e[1;31m'
        local GREEN='\e[1;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[1;34m'
        local RESET='\e[0m'
 echo -e "${YELLOW}[WARNING] ${1}${RESET}"
}

function echo_info()
{
        local RED='\e[1;31m'
        local GREEN='\e[1;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[1;34m'
        local RESET='\e[0m'

	echo -e "${BLUE}[INFO] ${1}${RESET}"
}


function build_mod_check()
{
	local CHECK_FILE=$1
	local bmod=$2
	
echo_info "Mod: $bmod,Check Lock:${CHECK_FILE}"
case "$bmod" in
        "force")
        break
        ;;
        "secure")
                if [ -f ${CHECK_FILE} ]; then
                        echo "Exist:${CHECK_FILE},bye!!!"
                        exit 0
                fi
        break
        ;;
        "prompt")
                if [ -f ${CHECK_FILE} ]; then
			echo "Exist:${CHECK_FILE}"
                        read -p "是否强制安装？(yes/no): " answer
                        if [ "$answer" != "yes" ]; then
                        exit 0
                        fi
                fi
        break
        ;;
        *)
        echo_error "Invalid bmod:$bmod"
        exit 1
        ;;
esac
	echo_info "go on"
	return 0
}


function build_mod_check_dir()
{
	local CHECK_FILE=$1
	local bmod=$2
	
echo_info "Mod: $bmod,Check Lock:${CHECK_FILE}"
case "$bmod" in
        "force")
        break
        ;;
        "secure")
                if [ -d ${CHECK_FILE} ]; then
                        echo "Exist:${JOBRUN_FILE},bye!!!"
                        exit 0
                fi
        break
        ;;
        "prompt")
                if [ -d ${CHECK_FILE} ]; then
			echo "Exist:${CHECK_FILE}"
                        read -p "是否强制安装？(yes/no): " answer
                        if [ "$answer" != "yes" ]; then
                        exit 0
                        fi
                fi
        break
        ;;
        *)
        echo_error "Invalid bmod:$bmod"
        exit 1
        ;;
esac
	echo_info "go on"
	return 0
}

function jarvis_next_step()
{
	local tips="$1"

	cnt=0	
	while [ "${JARVIS_NETXTSTEP}" == "ON" ]
	do
	cnt=$((cnt + 1))
	echo "CURRENT: $tips,cnt:$cnt"
	read -p "是否继续下一步？(yes/no): " answer
	if [ "$answer" == "yes" ]; then
		break
	fi
	done
	return 0
}

function get_mcpu()
{
	local implementer=$(cat /proc/cpuinfo | grep "CPU implementer" | awk 'NR==1{printf $4}')
	local part=$(cat /proc/cpuinfo | grep "CPU part" | awk 'NR==1{printf $4}')
	local cputype="${implementer}-${part}"
	local libdir="neon"
	local kblaslibdir="neon"
    if [ "${cputype}" = "0x48-0xd01" ]; then
        libdir="neon"
        kblaslibdir="neon"
    elif [ "${cputype}" = "0x48-0xd02" ]; then
        libdir="sve"
        kblaslibdir="sve"
    elif [ "${cputype}" = "0x48-0xd22" ]; then
        libdir="sve512"
        kblaslibdir="sme"
    else
        libdir="neon"
    fi
	echo "kblaslibdir"
}


### usage:[ -f "/etc/passwd" ] || assert $LINENO '[ -f "/etc/passwd" ]'
function assert() {
    local exit_code=$?
    local line_no=$1
    local cmd=$2

    if [ $exit_code -ne 0 ]; then
        echo "Assertion failed at line $line_no: $cmd" >&2
        exit $exit_code
    fi
}

function check_rpm_install(){
    local rpm_name=$1
    local ret=$(rpm -qa $rpm_name)
    if [[ "$ret" == "$rpm_name"* ]]; then
        return 0
    fi
    echo "error: need yum install" $rpm_name
    return 1
}

function check_install_path() {
	local mypath=$1
	local normalized_path=$(echo "$mypath" | sed 's:/*$::')
	[ -z "$normalized_path" ] && normalized_path="/"
	if [ "$normalized_path" = "/" ] || [ "$normalized_path" = "/usr" ] ; then
		echo "Invalid path: ${mypath}"
		exit 1
	fi
	return 0
}

function check_rpms_installed() {
	echo "Check installed RPMS:$@"
	for item in "$@"
	do
		local rpm_name="$item"
		local ret=$(rpm -qa "$rpm_name")
		if [[ "$ret" != "$rpm_name"* ]]; then
			echo "ERROR: yum install " "$item"
			return 1
		fi
	done
	return 0
}	


function rm_file_from_base()
{
	local args=("$@")
	local cnt=$#
	local i=1
	
	while [ $i -lt $cnt ];
	do
		if [ -f "${args[0]}/${args[$i]}" ]; then
			echo "rm file: ${args[0]}/${args[$i]}" && rm -f "${args[0]}/${args[$i]}"
		elif [ -d  "${args[0]}/${args[$i]}" ]; then
			echo "rm dir:${args[0]}/${args[$i]}" && rm -rf "${args[0]}/${args[$i]}"
		fi
		i=$((i+1))
	done
	return 0	
}
function diff_file_size()
{
	local afile=$1
	local bfile=$2
	[ -f ${afile} ] || return 1
	[ -f ${bfile} ] || return 1
	asize=$(stat -c %s ${afile})
       	bsize=$(stat -c %s ${bfile})
	[  ${asize} -eq ${bsize} ] && return 0
	return 1	
}


function file_contains() {
    local file1="$1"
    local file2="$2"
    # 检查文件是否存在
    if [[ ! -f "$file1" || ! -f "$file2" ]]; then
            echo "RES_CODE: 2, DES:file1 ${file1}, file2:${file2}"
        return 2
    fi

    # 使用comm命令，通过进程替换避免临时文件
    # 注意：comm要求输入已排序，所以我们先排序两个文件
    if comm -23 <(sort "$file2") <(sort "$file1") | grep -q .; then
        # 如果comm -23有输出，说明文件2中有行不在文件1中
        echo "RES_CODE: 1, DES:NOT SAME"
        return 1
    else
        echo "RES_CODE: 0"
        return 0
    fi
}
