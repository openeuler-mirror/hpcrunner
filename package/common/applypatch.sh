#!/bin/bash

# 定义补丁文件
PATCH_FILE=$1

# 尝试反向测试补丁是否已经应用
if patch -p0 -R -s --dry-run < "$PATCH_FILE" > /dev/null 2>&1; then
    echo "补丁已经应用，跳过。"
else
    echo "正在应用补丁..."
    patch -p0 < "$PATCH_FILE"
fi
