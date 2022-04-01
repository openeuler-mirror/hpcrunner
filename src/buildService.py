#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
from dataService import DataService
from executeService import ExecuteService

class BuildService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()

    def clean(self):
        print(f"start clean {DataService.app_name}")
        clean_cmd=self.hpc_data.get_clean_cmd()
        self.exe.exec_raw(clean_cmd)

    def build(self):
        print(f"start build {DataService.app_name}")
        build_cmd = self.hpc_data.get_build_cmd()
        self.exe.exec_raw(build_cmd)
