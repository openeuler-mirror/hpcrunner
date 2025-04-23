#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import logging
from asyncio.log import logger
from datetime import datetime
from toolService import ToolService
import subprocess

LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
DATE_FORMAT = "%m/%d/%Y %H:%M:%S %p"
logging.basicConfig(filename='runner.log', level=logging.DEBUG, format=LOG_FORMAT, datefmt=DATE_FORMAT)

class ExecuteService:
    def __init__(self):
        self.cur_time = ''
        self.end_time = ''
        self.tool = ToolService()
        self.flags = '*' * 80
        self.end_flag = 'END: '
        self.ROOT = os.getcwd()

    # tools function
    def join_cmd(self, arrs):
        return " && ".join(arrs)

    def print_cmd(self, cmd):
        print(self.flags)
        self.cur_time = self.tool.get_time_stamp()
        print(f"RUNNING at {self.cur_time}:\n{cmd}")
        logging.info(cmd)
        print(self.flags)

    # Execute, get output and don't know whether success or not
    def exec_popen(self, cmd, isPrint=True):
        if isPrint:
            self.print_cmd(cmd)
        output = os.popen(f"bash -c '{cmd} 2>&1'").readlines()
        return output

    def get_duration(self):
        time_1_struct = datetime.strptime(self.cur_time, "%Y-%m-%d %H:%M:%S")
        time_2_struct = datetime.strptime(self.end_time, "%Y-%m-%d %H:%M:%S")
        seconds = (time_2_struct - time_1_struct).seconds
        return seconds

    # Execute, get whether success or not
    def exec_list(self, cmds):
        cmd = self.join_cmd(cmds)
        if not cmd.startswith('echo'):
            self.print_cmd(cmd)
        state = os.system(f"bash -c '{cmd}'")
        self.end_time = self.tool.get_time_stamp()
        print(f"total time used: {self.get_duration()}s")
        logger.info(self.end_flag + cmd)
        if state:
            print(f"failed at {self.end_time}:{state}".upper())
            return False
        else:
            print(f"successfully executed at {self.end_time}, congratulations!!!".upper())
            return True

    def exec_raw(self, rows):
        return self.exec_list(self.tool.gen_list(rows))
    
    def exec_get_output(self, cmd):
        tmp_path = os.path.join(self.ROOT, 'tmp')
        tmp_file = os.path.join(tmp_path, 'tmp.txt')
        self.tool.mkdirs(tmp_path)
        cmd += f' &> {tmp_file}'
        self.exec_popen(cmd, False)
        info_list = self.tool.read_file(tmp_file).split('\n')
        return info_list

    def exec_inject(self, cmd_str):
        cmd = f'{cmd_str} && env -0'
        result = subprocess.run(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            text=True
        )
        # 处理错误并注入变量
        if result.returncode != 0:
            print(f"execute {cmd} failed: {result.stderr}")
            return
        for line in result.stdout.strip('\0').split('\0'):
            if '=' in line:
                key, value = line.split('=', 1)
                os.environ[key] = value
