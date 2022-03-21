#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import platform

from tool import Tool

class Data:
    # Hardware Info
    avail_ips=''
    # Dependent Software environment Info
    dependency = ''
    module_content=''
    env_file = 'env.sh'
    # Application Info
    app_name = ''
    build_dir = ''
    binary_dir =  ''
    binary_file = ''
    case_dir = ''

    # cmd info
    build_cmd = ''
    clean_cmd = ''
    run_cmd = {}
    batch_cmd = ''
    #Other Info
    meta_file = '.meta'
    root_path = os.getcwd()
    download_info = ''
    #perf info
    kperf_para = ''
    perf_para = ''
    nsys_para = ''
    ncu_para = ''
    def get_abspath(self, relpath):
        return os.path.join(Data.root_path, relpath)

    def __init__(self):
        self.isARM = platform.machine() == 'aarch64'
        self.tool = Tool()
        self.data_process()

    def get_file_name(self):
        file_name = 'data.config'
        if not os.path.exists(Data.meta_file):
            return file_name
        return self.tool.read_file(Data.meta_file)

    def get_data_config(self):
        file_name = self.get_file_name()
        file_path = self.get_abspath(file_name)
        with open(file_path, encoding='utf-8') as file_obj:
            contents = file_obj.read()
            return contents.strip()

    def is_empty(self, str):
        return len(str) == 0 or str.isspace() or str == '\n'

    def read_rows(self, rows, start_row):
        data = ''
        row = rows[start_row].strip()
        while not row.startswith('['):
            if not self.is_empty(row):
                data += row + '\n'
            start_row += 1
            if start_row == len(rows):
                break
            row = rows[start_row].strip()
        return start_row, data

    def read_rows_kv(self, rows, start_row):
        data = {}
        row = rows[start_row].strip()
        while not row.startswith('['):
            if '=' in row:
                key, value = row.split('=', 1)
                data[key.strip()] = value.strip()
            start_row += 1
            if start_row == len(rows):
                break
            row = rows[start_row].strip()
        return start_row, data

    def set_app_info(self, data):
        Data.app_name = data['app_name']
        Data.build_dir = data['build_dir']
        Data.binary_dir = data['binary_dir']
        Data.case_dir = data['case_dir']
    
    def set_perf_info(self, data):
        Data.kperf_para = data['kperf']
        Data.perf_para = data['perf']
        Data.nsys_para = data['nsys']
        Data.ncu_para = data['ncu']

    def split_two_part(self, data):
        split_list = data.split(' ', 1)
        first = split_list[0]
        second = ''
        if len(split_list) > 1:
            second = split_list[1]
        return (first, second)

    def data_process(self):
        contents = self.get_data_config()
        rows = contents.split('\n')
        rowIndex = 0
        data = {}
        perf_data = {}
        while rowIndex < len(rows):
            row = rows[rowIndex].strip()
            if row == '[SERVER]':
                rowIndex, Data.avail_ips = self.read_rows(rows, rowIndex+1)
            elif row == '[DOWNLOAD]':
                rowIndex, Data.download_info = self.read_rows(rows, rowIndex+1)
            elif row == '[DEPENDENCY]':
                rowIndex, Data.dependency = self.read_rows(rows, rowIndex+1)
            elif row == '[ENV]':
                rowIndex, Data.module_content = self.read_rows(rows, rowIndex+1)
            elif row == '[APP]':
                rowIndex, data = self.read_rows_kv(rows, rowIndex+1)
                self.set_app_info(data)
            elif row == '[BUILD]':
                rowIndex, Data.build_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[CLEAN]':
                rowIndex, Data.clean_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[RUN]':
                rowIndex, Data.run_cmd = self.read_rows_kv(rows, rowIndex+1)
            elif row == '[BATCH]':
                rowIndex, Data.batch_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[PERF]':
                rowIndex, perf_data = self.read_rows_kv(rows, rowIndex+1)
                self.set_perf_info(perf_data)
            else:
                rowIndex += 1
        Data.binary_file, Data.binary_para = self.split_two_part(Data.run_cmd['binary'])

    def get_clean_cmd(self):
        return f'''
cd {Data.build_dir}
{Data.clean_cmd}
'''
    def get_env(self):
        return f'''
./jarvis -e
source ./{Data.env_file}'''

    def get_build_cmd(self):
        return f'''
{self.get_env()}
cd {Data.build_dir}
{Data.build_cmd}
'''

    def get_run(self):
        nodes = int(Data.run_cmd['nodes'])
        run_cmd = Data.run_cmd['run']
        hostfile = ''
        if nodes > 1:
            hostfile = '--hostfile hostfile'
        if 'mpi' in run_cmd:
            run_cmd = f'{run_cmd} {hostfile}'
        binary = os.path.join(Data.binary_dir, Data.binary_file)
        return f'''{run_cmd} {binary} {Data.binary_para}'''

    def get_run_cmd(self):
        return  f'''
{self.get_env()}
cd {Data.case_dir}
{self.get_run()}
'''