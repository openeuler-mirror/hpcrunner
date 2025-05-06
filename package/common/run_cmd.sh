#!/bin/bash
command_name=$1
command_to_run=$2
LOG_FILE=$3
echo "Running: $command_name" | tee -a "$LOG_FILE"
# 使用 time 统计运行时间
echo "=== Time Statistics ===" | tee -a "$LOG_FILE"
( time -p eval $command_to_run ) 2>&1 | tee -a "$LOG_FILE"
echo "=========================" | tee -a "$LOG_FILE"
