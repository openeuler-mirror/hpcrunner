#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import subprocess
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService
def load_env_file(env_file):
    # 使用subprocess执行source命令
    result = subprocess.run(['bash', '-c', f'source {env_file} && env'], capture_output=True, text=True)
    env_vars = dict(line.split('=', 1) for line in result.stdout.splitlines() if '=' in line)
    return env_vars

def apply_env_to_shell(env_vars):
    # 将变量应用到当前shell
    for key, value in env_vars.items():
        os.environ[key] = value
        print(f"Applied: {key}={value}")



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
                print(f"key [{key}] not found in {config_file}, switch failed.")
                return
        self.tool.write_file(self.meta_path, config_file.strip())
        #os.system('bash -c "source dep_install/install_hpckit.sh"')
        env_file = "dep_install/install_hpckit.sh"  # 替换为实际环境变量文件
        env_vars = load_env_file(env_file)
        apply_env_to_shell(env_vars)
        print("Successfully switched. config file saved in file .meta")

