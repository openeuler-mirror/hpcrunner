#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import platform
import sys
import re

from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService

class PerfService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.isARM = platform.machine() == 'aarch64'

    def get_pid(self):
        #get pid
        pid_cmd = f'pidof {DataService.binary_file}'
        result = self.exe.exec_popen(pid_cmd)
        if len(result) == 0:
            print("failed to get pid.")
            sys.exit()
        else:
            pid_list = result[0].split(' ')
        mid = int(len(pid_list)/2)
        return pid_list[mid].strip()

    def perf(self):
        print(f"start perf {DataService.app_name}")
        #get pid
        pid = self.get_pid()
        #start perf && analysis
        perf_cmd = f'''
perf record {DataService.perf_para} -a -g -p {pid}
perf report  -i ./perf.data -F period,sample,overhead,symbol,dso,comm -s overhead --percent-limit 0.1% --stdio
'''
        self.exe.exec_raw(perf_cmd)

    def get_arch(self):
        arch = 'arm'
        if not self.isARM:
            arch = 'X86'
        return arch

    def get_cur_time(self):
        return re.sub(' |:', '-', self.tool.get_time_stamp())

    def gpu_perf(self):
        print(f"start gpu perf")
        run_cmd = self.hpc_data.get_run()
        gperf_cmd = f'''
{self.hpc_data.get_env()}
cd {DataService.case_dir}
nsys profile -y 5s -d 100s {DataService.nsys_para} -o nsys-{self.get_arch()}-{self.get_cur_time()} {run_cmd}
    '''
        self.exe.exec_raw(gperf_cmd)

    def ncu_perf(self, kernel):
        print(f"start ncu perf")
        run_cmd = self.hpc_data.get_run()
        ncu_cmd = f'''
{self.hpc_data.get_env()}
cd {DataService.case_dir}
ncu --export ncu-{self.get_arch()}-{self.get_cur_time()} {DataService.ncu_para} --import-source=yes --set full --kernel-name {kernel} --launch-skip 1735 --launch-count 1 {run_cmd}
'''
        self.exe.exec_raw(ncu_cmd)

