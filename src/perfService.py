#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import platform
import sys
import re
import os
from glob import glob

from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService

class PerfService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
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
yum install -y perf
perf record {DataService.perf_para} -a -g -p {pid}
perf report  -i ./perf.data -F period,sample,overhead,symbol,dso,comm -s overhead --percent-limit 0.1% --stdio
'''
        self.exe.exec_raw(perf_cmd)
        
    def kperf(self):
        print(f"start kperf {DataService.app_name}")
        python3_libs_path = './software/libs/python3/'
        #get pid
        pid = self.get_pid()
        kperf_script = os.path.join(python3_libs_path,'kperf', 'src/kperf.py')
        kperf_log = '> kperf.data.txt'
        #start kperf
        kperf_cmd = f'''
chmod +x {kperf_script}
python3 {kperf_script} --rawdata --hotfunc --topdown --cache --tlb --imix {DataService.kperf_para} --duration 1 --interval 15 --pid {pid} {kperf_log}
'''
        self.exe.exec_raw(kperf_cmd)
        print("kperf.data.txt is generated")

    def get_arch(self):
        arch = 'arm'
        if not self.isARM:
            arch = 'X86'
        return arch

    def get_cur_time(self):
        return re.sub(' |:', '-', self.tool.get_time_stamp())

    def gpu_perf(self):
        print("start gpu perf")  
        run_cmd = self.hpc_data.get_run()  
        env_cmd = self.hpc_data.get_env()  
        nsys_para = '-y 5s -d 100s'  
        if DataService.nsys_para:  
            nsys_para = DataService.nsys_para  
        
        output_file = f"nsys-{self.get_arch()}-{self.get_cur_time()}"  
        gperf_cmd = f"{env_cmd}\ncd {DataService.case_dir}\nnsys profile {nsys_para} -o {output_file} {run_cmd}"  
        
        self.exe.exec_raw(gperf_cmd)

    def ncu_perf(self, kernel):
        print(f"start ncu perf")
        run_cmd = self.hpc_data.get_run()
        ncu_para = '--launch-skip 1735 --launch-count 1'
        if DataService.ncu_para != '':
            ncu_para = DataService.ncu_para
        ncu_cmd = f'''
{self.hpc_data.get_env()}
cd {DataService.case_dir}
ncu --export ncu-{self.get_arch()}-{self.get_cur_time()} --import-source=yes --set full --kernel-name {kernel} {ncu_para} {run_cmd}
'''
        self.exe.exec_raw(ncu_cmd)

    def compared_version(self, ver1, ver2):
        '''
            传入不带英文的版本号,特殊情况："10.12.2.6.5">"10.12.2.6"
            :param ver1: 版本号1
            :param ver2: 版本号2
            :return: ver1< = >ver2返回-1/0/1
        '''
        list1 = str(ver1).split(".")
        list2 = str(ver2).split(".")
        # 循环次数为短的列表的len
        for i in range(len(list1)) if len(list1) < len(list2) else range(len(list2)):
            if int(list1[i]) == int(list2[i]):
                pass
            elif int(list1[i]) < int(list2[i]):
                return -1
            else:
                return 1
        # 循环结束，哪个列表长哪个版本号高
        if len(list1) == len(list2):
            return 0
        elif len(list1) < len(list2):
            return -1
        else:
            return 1
    
    def get_maximum_version(self, version_path):
        file_list = [d for d in glob(version_path+'/**', recursive=False)]
        max_version = '0.0'
        for file in file_list:
            if os.path.isdir(file):
                version = os.path.basename(file)
                if self.compared_version(max_version, version):
                    max_version = version
        return max_version
                
    def hpctool_perf(self):
        print(f"start hpctool perf")
        output_file = f'output-{self.get_cur_time()}'
        hpctool_path = os.path.join(self.ROOT, 'software/utils/hpctool')
        max_version = self.get_maximum_version(hpctool_path)
        #collect
        hpccollect_path = f'$JARVIS_UTILS/hpctool/{max_version}/bin/hpccollect'
        hpccollect_para = f' -l detail -o ./{output_file}'
        if DataService.hpccollect_para != '':
            hpccollect_para = DataService.hpccollect_para + hpccollect_para
        collect_cmd = self.hpc_data.get_run(f'{hpccollect_path} {hpccollect_para}')
        #analysis
        hpcreport_path = f'$JARVIS_UTILS/hpctool/{max_version}/bin/hpcreport'
        if 'mpi' not in collect_cmd:
            hpcreport_para = f'-i ./{output_file}.v{max_version}.hpcstat hotspots -g parallel-region function'
        else:
            hpcreport_para = f'-i ./{output_file}.v{max_version}.hpcstat mpi-wait -g function'
        if DataService.hpcreport_para != '':
            hpcreport_para = DataService.hpcreport_para
        report_cmd = f'{hpcreport_path} {hpcreport_para}'
        collect_and_report_cmd = f'''
{self.hpc_data.get_env()}
./jarvis -install hpctool/{max_version} any
echo "1">/proc/sys/kernel/perf_event_paranoid
cd {DataService.case_dir}
{collect_cmd}
{report_cmd}
'''
        self.exe.exec_raw(collect_and_report_cmd)