#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import platform
import os
from glob import glob

from executeService import ExecuteService

class BenchmarkService:
    def __init__(self):
        self.isARM = platform.machine() == 'aarch64'
        self.ROOT = os.getcwd()
        self.exe = ExecuteService()
        self.RUN_FILE = 'run.sh'
        self.ALL = 'all'
    
    def output_bench_info(self, bench_case):
        bench_path = os.path.join(self.ROOT, 'benchmark')
        file_list = [d for d in glob(bench_path+'/**', recursive=False)]
        for file in file_list:
            cur_bench_case = os.path.basename(file)
            run_file = os.path.join(file, self.RUN_FILE)
            if os.path.isdir(file) and os.path.exists(run_file):
                cmd = f"cd {file} && chmod +x  {self.RUN_FILE} && ./{self.RUN_FILE}"
                if cur_bench_case == self.ALL or cur_bench_case == bench_case:
                    self.exe.exec_raw(cmd)
