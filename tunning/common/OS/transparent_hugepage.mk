透明大页（Transparent Huge Pages，THP）是一种内存管理技术，可提高Linux系统的性能，为了减少应用程序中的内存碎片并提高内存使用效率，它通过将多个物理页面组合成一个更大的虚拟内存完成工作。
1.确认系统内核是否支持THP功能
cat /sys/kernel/mm/transparent_hugepage/enabled
该命令将返回一个值，说明是否已启用透明大页。如果返回always或madvise [never]，则表示支持THP。如果返回[never]，则需要启用它。

2.设置内存大页数量(1个2M,通常设置为总内存的5%左右，比如16G内存设置1024个比较合适，这里应根据应用实际情况进行调整)
sysctl -w vm.nr_hugepages=1024

3.启用透明大页
echo always > /sys/kernel/mm/transparent_hugepage/enabled

4.检查是否生效
grep -i huge /proc/meminfo
显示如下
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:     524288 kB
Hugetlb:               0 kB
如果输出结果中的HugePages_Total和HugePages_Free都不为0，表示生效了