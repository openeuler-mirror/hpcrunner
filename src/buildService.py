#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService

class BuildService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()

    def clean(self):
        print(f"start clean {DataService.app_name}")
        clean_cmd=self.hpc_data.get_clean_cmd()
        self.exe.exec_raw(clean_cmd)

    def build(self):
        print(f"start build {DataService.app_name}")
        build_cmd = self.hpc_data.get_build_cmd()
        build_file = 'build.sh'
        self.tool.write_file(build_file, build_cmd)
        run_cmd = f'''
chmod +x {build_file}
./{build_file}
'''
        self.exe.exec_raw(run_cmd)
