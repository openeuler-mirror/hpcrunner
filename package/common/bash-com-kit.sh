old_ddr_size=0
old_hbm_size=0
new_ddr_size=2044
new_hbm_size=0

export MEMKIND_HBW_NODES=0-15
function cache_mod_ddr_size_start () 
{
ddr_size=${new_ddr_size}
hbm_size=${new_hbm_size}

for i in $(seq 0 15);
do
        old_ddr_size=$(cat /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages)
        echo ${ddr_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
done

echo "reserve ${ddr_size} x 2M huge page for DDR done, old_ddr_size=${old_ddr_size}"

for i in $(seq 16 31);
do
        if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
        old_hbm_size=$(cat /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages)
        echo ${hbm_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
        fi
done
i=16
if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
echo "reserve ${hbm_size} x 2M huge page for HBM done,old_hbm_size=${old_hbm_size}"
fi
}


function cache_mod_ddr_size_restore () 
{
ddr_size=${old_ddr_size}
hbm_size=${old_hbm_size}

for i in $(seq 0 15);
do
        echo ${ddr_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
done

echo "restore ${ddr_size} x 2M huge page for DDR done"

for i in $(seq 16 31);
do
        if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
                echo ${hbm_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
        fi
done
i=16
if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
echo "restore  ${hbm_size} x 2M huge page for HBM done"
fi
}
### end cache mode optimization

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

