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
        config_path = os.path.join(self.ROOT, config_file)
        if not os.path.isfile(config_path):
            print("config_path not found, switch failed.")
            return
        contents = self.tool.read_file(config_file)
        # keys should contains in config
        keys = ["DOWNLOAD","DEPENDENCY","ENV","APP","BUILD","RUN"]
        for key in keys:
            if f"[{key}]" not in contents:
                print(f"key [{key}] not found, switch failed.")
                self.tool.del_file(self.meta_path)
            return
        self.tool.write_file(self.meta_path, config_file.strip())
        print("Successfully switched. config file saved in file .meta")

