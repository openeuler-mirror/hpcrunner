#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import platform

from toolService import ToolService

class Singleton(type):

    def __init__(self, name, bases, dictItem):
        super(Singleton,self).__init__(name,bases, dictItem)
        self._instance = None

    def __call__(self, *args, **kwargs):
        if self._instance is None:
            self._instance = super(Singleton,self).__call__(*args, **kwargs)
        return self._instance

class DataService(object,metaclass=Singleton):
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
    config_file = 'data.config'
    meta_file = '.meta'
    root_path = os.getcwd()
    download_info = ''
    #perf info
    kperf_para = ''
    perf_para = ''
    nsys_para = ''
    ncu_para = ''
    hpccollect_para = ''
    hpcreport_para = ''
    def get_abspath(self, relpath):
        return os.path.join(DataService.root_path, relpath)

    def __init__(self):
        self.isARM = platform.machine() == 'aarch64'
        self.tool = ToolService()
        self.data_process()

    def get_config_file_name(self):
        if not os.path.exists(DataService.meta_file):
            return DataService.config_file
        return self.tool.read_file(DataService.meta_file)

    def get_data_config(self):
        file_name = self.get_config_file_name()
        file_path = self.get_abspath(file_name)
        if not os.path.exists(file_path):
            print("config file not found, switch to default data.config.")
            file_path = self.get_abspath(DataService.config_file)
        with open(file_path, encoding='utf-8') as file_obj:
            contents = file_obj.read()
            return contents.strip()

    def is_empty(self, content):
        return len(content) == 0 or content.isspace() or content == '\n'

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
        DataService.app_name = data['app_name']
        DataService.build_dir = data['build_dir']
        DataService.binary_dir = data['binary_dir']
        DataService.case_dir = data['case_dir']
    
    def set_perf_info(self, data):
        DataService.kperf_para = data['kperf'] if 'kperf' in data else ''
        DataService.perf_para = data['perf'] if 'perf' in data else ''
        DataService.nsys_para = data['nsys'] if 'nsys' in data else ''
        DataService.ncu_para = data['ncu'] if 'ncu' in data else ''
        DataService.hpccollect_para = data['hpccollect'] if 'hpccollect' in data else ''
        DataService.hpcreport_para = data['hpcreport'] if 'hpcreport' in data else ''

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
                rowIndex, DataService.avail_ips = self.read_rows(rows, rowIndex+1)
            elif row == '[DOWNLOAD]':
                rowIndex, DataService.download_info = self.read_rows(rows, rowIndex+1)
            elif row == '[DEPENDENCY]':
                rowIndex, DataService.dependency = self.read_rows(rows, rowIndex+1)
            elif row == '[ENV]':
                rowIndex, DataService.module_content = self.read_rows(rows, rowIndex+1)
            elif row == '[APP]':
                rowIndex, data = self.read_rows_kv(rows, rowIndex+1)
                self.set_app_info(data)
            elif row == '[BUILD]':
                rowIndex, DataService.build_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[CLEAN]':
                rowIndex, DataService.clean_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[RUN]':
                rowIndex, DataService.run_cmd = self.read_rows_kv(rows, rowIndex+1)
            elif row == '[BATCH]':
                rowIndex, DataService.batch_cmd = self.read_rows(rows, rowIndex+1)
            elif row == '[PERF]':
                rowIndex, perf_data = self.read_rows_kv(rows, rowIndex+1)
                self.set_perf_info(perf_data)
            else:
                rowIndex += 1
        DataService.binary_file, DataService.binary_para = self.split_two_part(DataService.run_cmd['binary'])

    def get_clean_cmd(self):
        return f'''
{self.get_env()}
cd {DataService.build_dir}
{DataService.clean_cmd}
'''
    def get_env(self):
        return f'''source ./init.sh
./jarvis -e
source ./{DataService.env_file}'''

    def get_build_cmd(self):
        return f'''
{self.get_env()}
cd {DataService.build_dir}
{DataService.build_cmd}
'''

    def get_run(self):
        nodes = int(DataService.run_cmd['nodes'])
        run_cmd = DataService.run_cmd['run']
        hostfile = ''
        if nodes > 1:
            hostfile = f'--hostfile {DataService.root_path}/hostfile'
        if 'mpi' in run_cmd:
            run_cmd = run_cmd.replace('mpirun', f'mpirun {hostfile}')
        binary = os.path.join(DataService.binary_dir, DataService.binary_file)
        return f'''{run_cmd} {binary} {DataService.binary_para}'''

    def get_run_cmd(self):
        return  f'''
{self.get_env()}
cd {DataService.case_dir}
{self.get_run()}
'''
