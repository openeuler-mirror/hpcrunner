#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os

from dataService import DataService
from toolService import ToolService
from executeService import ExecuteService

class EnvService:
    def __init__(self):
        self.hpc_data = DataService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.exe = ExecuteService()

    def env(self):
        print(f"set environment {DataService.app_name}")
        env_file = os.path.join(self.ROOT, DataService.env_file)
        self.tool.write_file(env_file, DataService.module_content)
        print(f"ENV FILE {DataService.env_file} GENERATED.")
        self.exe.exec_raw(f'chmod +x {DataService.env_file}')
