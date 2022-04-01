#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService

class ConfigService:
    def __init__(self):
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.meta_path = os.path.join(self.ROOT, DataService.meta_file)

    def switch_config(self, config_file):
        print(f"Switch config file to {config_file}")
        self.tool.write_file(self.meta_path, config_file.strip())
        print("Successfully switched.")

