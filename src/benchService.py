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
        """
        Output benchmark information for a specific benchmark case.

        Parameters:
        - bench_case (str): The benchmark case to output information for.
        """
        bench_path = os.path.join(self.ROOT, 'benchmark')
        file_list = [d for d in glob(os.path.join(bench_path, '**'), recursive=False)]
        
        for file in file_list:
            cur_bench_case = os.path.basename(file)
            run_file = os.path.join(file, self.RUN_FILE)
            
            if os.path.isdir(file) and os.path.exists(run_file):
                self.set_execute_permissions(run_file)
                
                if cur_bench_case == self.ALL or cur_bench_case == bench_case:
                    self.execute_benchmark(file)
    
    def set_execute_permissions(self, file_path):
        """
        Set execute permissions for a file.

        Parameters:
        - file_path (str): The path of the file for which execute permissions should be set.
        """
        try:
            os.chmod(file_path, 0o755)
        except OSError as e:
            print(f"Error setting execute permissions for {file_path}: {e}")
    
    def execute_benchmark(self, folder_path):
        """
        Execute the benchmark located in the specified folder.

        Parameters:
        - folder_path (str): The path of the folder containing the benchmark.
        """
        try:
            cmd = f"cd {folder_path} && ./{self.RUN_FILE}"
            self.exe.exec_raw(cmd)
        except Exception as e:
            print(f"Error executing benchmark in {folder_path}: {e}")