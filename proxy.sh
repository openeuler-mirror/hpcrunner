#!/bin/bash

# 定义代理URL
declare -A proxies=(
    [1]="https://github.com"
    [2]="https://gh.ddlc.top/https://github.com"
    [3]="https://gh.con.sh/https://github.com"
    [4]="https://hub.gitmirror.com/https://github.com"
    [5]="https://ghproxy.com/https://github.com"
	[6]="https://ghproxy.cc/https://github.com"
)

echo '输入 1 到 7 之间的数字，选择合适的git源'
echo '1) 官方源'
echo '2) 美国高速源1'
echo '3) 美国高速源2'
echo '4) 美国高速源3'
echo '5) 韩国高速源1'
echo '6) 韩国高速源2'
echo '7) Gitee高速源'
echo '8) 恢复官方源'

read -p '你输入的数字为: ' aNum

if [[ $aNum =~ ^[1-6]$ ]]; then
    # 更新init.sh中的代理URL
    sed -i -e "s|JARVIS_PROXY=.*|JARVIS_PROXY=${proxies[$aNum]}|g" init.sh
	source ./init.sh
elif [[ $aNum -eq 'a' ]]; then
    # 备份并替换dataService.py文件
    rm -rf src/dataService.py
    cp src/dataService.py.fast src/dataService.py
elif [[ $aNum -eq 'b' ]]; then
    # 恢复dataService.py文件
    rm -rf src/dataService.py
    cp src/dataService.py.ori src/dataService.py
else
    echo '无效输入，请输入 1 到 7 之间的数字'
fi