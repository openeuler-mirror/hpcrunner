#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
from dataService import DataService
from toolService import ToolService

class ConfigService:
    def __init__(self):
        self.ds = DataService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.meta_path = os.path.join(self.ROOT, self.ds.META_FILE)

    def switch_config(self, config_file):
        print(f"Switch config file to {config_file}")
        config_path = os.path.join(self.ROOT, config_file)
        if not os.path.isfile(config_path):
            print("config_path not found, switch failed.")
            return
        contents = self.tool.read_file(config_file)
        # keys should contains in config
        keys = self.ds.KEY_CONFIG_SECTIONS
        for key in keys:
            if f"[{key}]" not in contents:
                print(f"key [{key}] not found in {config_file}, switch failed.")
                return
        self.tool.write_file(self.meta_path, config_file.strip())
        print("Successfully switched. config file saved in file .meta")

