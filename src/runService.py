#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import sys
from toolService import ToolService
from executeService import ExecuteService
from dataService import DataService
from commandBuilder import CommandBuilder

class RunService:
    def __init__(self):
        self.ds = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.command = CommandBuilder()  # 注入命令生成组件
        self.ROOT = os.getcwd()
        self.avail_ips_list = self.tool.gen_list(self.ds.get_available_ips())

    def gen_hostfile(self, nodes):
        length = len(self.avail_ips_list)
        if nodes > length:
            print(f"You don't have {nodes} nodes, only {length} nodes available!")
            sys.exit()
        if nodes <= 1:
            return
        gen_nodes = '\n'.join(self.avail_ips_list[:nodes])
        print(f"HOSTFILE\n{gen_nodes}\nGENERATED.")
        self.tool.write_file('hostfile', gen_nodes)

    # single run
    def run(self):
        print(f"start run {self.ds.get_app_name()}")
        nodes = int(self.ds.get_run_cmd('nodes'))
        self.gen_hostfile(nodes)
        run_cmd = self.command.full_run()
        self.exe.exec_raw(run_cmd)

    def batch_run(self):
        batch_cmd = self.command.batch_run()
        self.exe.exec_raw(run_cmd)

    def job_run(self,num):
        job_cmd = self.command.job_run(num)
        self.exe.exec_raw(job_cmd)
