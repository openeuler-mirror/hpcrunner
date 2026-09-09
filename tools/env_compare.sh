#!/bin/bash
# =============================================================================
# 功能: 对比两台Linux服务器的环境差异
# =============================================================================

show_help() {
    cat << 'EOF'
用法: bash env_compare.sh <dir1> <dir2>

功能描述:
    该脚本需要两个必需参数：2个环境的全量配置信息路径

选项:
    -h, --help  显示此帮助信息并退出

示例:
    ./env_compare.sh /dir1 /dir2
    ./env_compare.sh -h
    ./env_compare.sh --help

EOF
    exit 0
}

# ----------------------------- 参数解析 --------------------------------------

# 解析选项参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -*)
            echo "错误: 未知选项 '$1'"
            echo "使用 '-h' 或 '--help' 查看帮助信息"
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# ----------------------------- 参数数量校验 ----------------------------------

if [[ $# -ne 2 ]]; then
    echo "错误: 参数数量不正确，需要 2 个参数，实际传入 $# 个"
    echo ""
    echo "用法: $0 <dir1> <dir2>"
    echo "使用 '$0 -h' 或 '$0 --help' 查看详细帮助"
    exit 1
fi

# ----------------------------- 配置区 ----------------------------------------
DIR1="${1:-}"
DIR2="${2:-}"

if [ -z "$DIR1" ] || [ -z "$DIR2" ]; then
    echo "用法: $0 <dir1> <dir2>"
    exit 1
fi

CUR_DIR=$(dirname $(readlink -f $0))
DIFF_DIR="$CUR_DIR/diff"

mkdir -p "$DIFF_DIR"

echo "================================================================================"
echo "  Linux 环境差异对比工具"
echo "  环境1目录: $DIR1"
echo "  环境2目录: $DIR2"
echo "================================================================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

TOTAL_CHECKS=0
DIFF_CHECKS=0

# =============================================================================
# 对比函数
# =============================================================================

compare_file() {
    local label="$1"
    local file="$2"
    local local_file="$DIR1/$file"
    local remote_file="$DIR2/$file"
    local diff_file="$DIFF_DIR/$file.diff"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if [ ! -f "$local_file" ] && [ ! -f "$remote_file" ]; then
        return
    fi
    if [ ! -f "$local_file" ]; then
        echo -e "  ${YELLOW}[WARN]${NC} $label — 本地文件不存在"
        return
    fi
    if [ ! -f "$remote_file" ]; then
        echo -e "  ${YELLOW}[WARN]${NC} $label — 远程文件不存在"
        return
    fi

    if diff -q "$local_file" "$remote_file" > /dev/null 2>&1; then
        echo -e "  ${GREEN}[相同]${NC} $label"
    else
        DIFF_CHECKS=$((DIFF_CHECKS + 1))
        echo -e "  ${RED}[差异]${NC} $label"
        diff -u "$local_file" "$remote_file" > "$diff_file" 2>/dev/null || \
            diff "$local_file" "$remote_file" > "$diff_file" 2>/dev/null || true
    fi
}

compare_rpm() {
    local local_file="$DIR1/01_rpm_packages.txt"
    local remote_file="$DIR2/01_rpm_packages.txt"
    local diff_file="$DIFF_DIR/01_rpm_packages.diff"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if [ ! -f "$local_file" ] || [ ! -f "$remote_file" ]; then
        echo -e "  ${YELLOW}[WARN]${NC} RPM包列表 — 文件缺失"
        return
    fi

    awk '{print $1}' "$local_file" | sort > "$DIR1/01_rpm_names.txt"
    awk '{print $1}' "$remote_file" | sort > "$DIR2/01_rpm_names.txt"

    local_only=$(comm -23 "$DIR1/01_rpm_names.txt" "$DIR2/01_rpm_names.txt" 2>/dev/null | wc -l)
    remote_only=$(comm -13 "$DIR1/01_rpm_names.txt" "$DIR2/01_rpm_names.txt" 2>/dev/null | wc -l)
    version_diff=$(diff "$local_file" "$remote_file" 2>/dev/null | grep -c '^[<>]' || true)

    if [ "$local_only" -eq 0 ] && [ "$remote_only" -eq 0 ] && [ "$version_diff" -eq 0 ]; then
        echo -e "  ${GREEN}[相同]${NC} RPM包列表"
    else
        DIFF_CHECKS=$((DIFF_CHECKS + 1))
        echo -e "  ${RED}[差异]${NC} RPM包列表 — $DIR1独有:${local_only} $DIR2独有:${remote_only} 版本差异:${version_diff}"
        {
            echo "=== 仅存在于 $DIR1 的包 ==="
            comm -23 "$DIR1/01_rpm_names.txt" "$DIR2/01_rpm_names.txt" 2>/dev/null || true
            echo ""
            echo "=== 仅存在于 $DIR2 的包 ==="
            comm -13 "$DIR1/01_rpm_names.txt" "$DIR2/01_rpm_names.txt" 2>/dev/null || true
            echo ""
            echo "=== 版本差异 ==="
            diff "$local_file" "$remote_file" 2>/dev/null || true
        } > "$diff_file"
    fi
}

compare_services_running() {
    local local_file="$DIR1/02_services_running.txt"
    local remote_file="$DIR2/02_services_running.txt"
    local diff_file="$DIFF_DIR/02_services_running.diff"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if [ ! -f "$local_file" ] || [ ! -f "$remote_file" ]; then
        echo -e "  ${YELLOW}[WARN]${NC} 运行中服务 — 文件缺失"
        return
    fi

    local_only=$(comm -23 "$local_file" "$remote_file" 2>/dev/null | wc -l)
    remote_only=$(comm -13 "$local_file" "$remote_file" 2>/dev/null | wc -l)

    if [ "$local_only" -eq 0 ] && [ "$remote_only" -eq 0 ]; then
        echo -e "  ${GREEN}[相同]${NC} 运行中服务"
    else
        DIFF_CHECKS=$((DIFF_CHECKS + 1))
        echo -e "  ${RED}[差异]${NC} 运行中服务 — $DIR1多运行:${local_only} $DIR2多运行:${remote_only}"
        {
            echo "=== 仅 $DIR1 运行 ==="
            comm -23 "$local_file" "$remote_file" 2>/dev/null || true
            echo ""
            echo "=== 仅 $DIR2 运行 ==="
            comm -13 "$local_file" "$remote_file" 2>/dev/null || true
        } > "$diff_file"
    fi
}

compare_sysctl() {
    local local_file="$DIR1/04_sysctl_all.txt"
    local remote_file="$DIR2/04_sysctl_all.txt"
    local diff_file="$DIFF_DIR/04_sysctl_all.diff"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if [ ! -f "$local_file" ] || [ ! -f "$remote_file" ]; then
        echo -e "  ${YELLOW}[WARN]${NC} sysctl参数 — 文件缺失"
        return
    fi

    local filtered_local="$DIR1/04_sysctl_filtered.txt"
    local filtered_remote="$DIR2/04_sysctl_filtered.txt"

    grep -v -E '^(fs\.file-nr|kernel\.random\.|net\.netfilter\.nf_conntrack_count|vm\.stat|kernel\.sched_domain)' \
        "$local_file" > "$filtered_local" 2>/dev/null || cp "$local_file" "$filtered_local"
    grep -v -E '^(fs\.file-nr|kernel\.random\.|net\.netfilter\.nf_conntrack_count|vm\.stat|kernel\.sched_domain)' \
        "$remote_file" > "$filtered_remote" 2>/dev/null || cp "$remote_file" "$filtered_remote"

    if diff -q "$filtered_local" "$filtered_remote" > /dev/null 2>&1; then
        echo -e "  ${GREEN}[相同]${NC} sysctl参数（已过滤动态值）"
    else
        DIFF_CHECKS=$((DIFF_CHECKS + 1))
        echo -e "  ${RED}[差异]${NC} sysctl参数"
        diff -u "$filtered_local" "$filtered_remote" > "$diff_file" 2>/dev/null || \
            diff "$filtered_local" "$filtered_remote" > "$diff_file" 2>/dev/null || true
    fi
}

# =============================================================================
# 主流程
# =============================================================================

compare_rpm
compare_services_running
compare_file "所有服务状态" "03_services_all.txt"
compare_sysctl
compare_file "sysctl.conf" "05_sysctl_conf.txt"
compare_file "sysctl.d配置" "05_sysctl_d.txt"
compare_file "内核启动参数" "06_kernel_cmdline.txt"
compare_file "/etc/profile" "07_etc_profile.txt"
compare_file "/etc/bashrc" "07_etc_bashrc.txt"
compare_file "/etc/environment" "07_etc_environment.txt"
compare_file "用户列表(/etc/passwd)" "08_passwd.txt"
compare_file "用户组(/etc/group)" "08_group.txt"
compare_file "系统用户(/etc/shadow)" "08_shadow_users.txt"
compare_file "定时任务" "09_cron.txt"
compare_file "root crontab" "09_root_crontab.txt"
compare_file "SELinux状态" "10_selinux_status.txt"
compare_file "SELinux配置" "10_selinux_config.txt"
compare_file "iptables规则" "11_iptables.txt"
compare_file "firewalld配置" "11_firewalld.txt"
compare_file "firewalld zones" "11_firewalld_zones.txt"
compare_file "IP地址" "12_ip_addr.txt"
compare_file "路由表" "12_ip_route.txt"
compare_file "DNS配置" "12_resolv.conf.txt"
compare_file "/etc/hosts" "12_hosts.txt"
compare_file "主机名" "12_hostname.txt"
compare_file "网卡脚本配置" "13_network_scripts.txt"
compare_file "挂载点" "14_mount.txt"
compare_file "/etc/fstab" "14_fstab.txt"
compare_file "磁盘使用" "14_df.txt"
compare_file "limits.conf" "15_limits.conf.txt"
compare_file "limits.d配置" "15_limits_d.txt"
compare_file "ulimit" "15_ulimit.txt"
compare_file "内核模块" "16_lsmod.txt"
compare_file "modprobe配置" "16_modprobe.txt"
compare_file "时区设置" "17_timedatectl.txt"
compare_file "localtime MD5" "17_localtime_md5.txt"
compare_file "timezone文件" "17_timezone.txt"
compare_file "locale" "18_locale.txt"
compare_file "locale.conf" "18_locale_conf.txt"
compare_file "SSH配置" "19_sshd_config.txt"
compare_file "rsyslog.conf" "20_rsyslog.conf.txt"
compare_file "rsyslog.d配置" "20_rsyslog_d.txt"
compare_file "OS版本" "21_os_release.txt"
compare_file "内核版本" "21_uname.txt"
compare_file "GRUB配置" "22_grub.txt"
compare_file "systemd配置" "23_systemd.conf.txt"
compare_file "journald配置" "23_journald.conf.txt"
compare_file "useradd默认配置" "24_default_useradd.txt"

compare_file "ulimit配置" 25_ulimit.txt
compare_file "free -g" 26_free.txt
compare_file "meminfo" 27_meminfo.txt
compare_file "dmidecode" 28_dmidecode.txt
compare_file "cmdline" 29_cmdline.txt
compare_file "filesystems" 30_filesystems.txt
compare_file "fstab" 31_fstab.txt
compare_file "lsblk" 32_lsblk.txt
compare_file "vgdisplay" 33_vgdisplay.txt
compare_file "lvdisplay" 34_lvdisplay.txt
compare_file "block device" 35_block_device.txt
compare_file "nic ethtool" 36_nic_ethtool.txt
compare_file "exagear-x86_64" 37_exagear-x86_64_conf.txt
compare_file "exagear-x86_32" 38_exagear-x86_32_conf.txt
compare_file "exagear-default_conf" 39_exagear-default_conf.txt

echo "--------------------------------------------------------------------------------"
echo ""
echo -e "${BOLD}对比结果汇总:${NC}"
echo "  总检查项: $TOTAL_CHECKS"
echo -e "  ${GREEN}相同项: $((TOTAL_CHECKS - DIFF_CHECKS))${NC}"
echo -e "  ${RED}差异项: $DIFF_CHECKS${NC}"
echo ""
echo "详细差异文件保存在: $DIFF_DIR"
echo ""

if [ "$DIFF_CHECKS" -gt 0 ]; then
    echo -e "${RED}${BOLD}存在差异的配置项:${NC}"
    for f in "$DIFF_DIR"/*.diff; do
        [ -f "$f" ] || continue
        name=$(basename "$f" .diff)
        lines=$(wc -l < "$f" 2>/dev/null || echo 0)
        echo "  - $name (${lines}行差异)"
    done
    echo ""
fi

echo "================================================================================"
echo "检查完成"
echo "================================================================================"
