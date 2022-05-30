本工具适用于对比查找arm平台和x86平台精度差异，指导开发人员修复精度不一致问题。
本工具原理架构可参考《鲲鹏计算精度白皮书》：
https://bbs.huaweicloud.com/forum/thread-176980-1-1.html

工具使用条件约束：
1.本工具使用到GDB调试功能和依赖二进制中的符号表，需要待分析应用编译选项优化等级改至-O0和增加-g选项。
2.本工具只支持单线程运行，且不支持openMP。


环境要求：
1.需要arm服务器和x86服务器各一台。
2.服务器上需要安装gdb（V10.2）和expect。


工具使用方法：
1.修改编译选项:编译优化等级更改为-O0，增加-g，删除-fopenmp、-qopenmp等并行编译选项。
2.将lib文件夹下的libprint_md5.so动态库放在对应的服务器上，修改应用编译脚本，将动态库文件链接进目标应用。
3.将arm文件夹下的文件放在arm服务器上的应用、算例的同一目录下，将x86文件夹下的文件放在x86服务器上的应用、算例的同一目录下
4.在arm服务器下执行./hawkeys.sh program srcdir filename num1 num2 x86_ip x86_password x86_workdir
program：应用二进制名称
srcdir: 应用源码目录
filename：待检测精度的代码文件名称
num1：待检测精度的代码文件开始行号
num2：待检测精度的代码文件结束行号
x86_ip：x86服务器ip
x86_password：默认使用root账号，x86服务器root密码
x86_workdir：x86服务器下的运行目录

5.arm和x86运行结果对比输出：
1.在arm服务器下执行./printresult.sh srcdir
srcdir: 应用源码目录
