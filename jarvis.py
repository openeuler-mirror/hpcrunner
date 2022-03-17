#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import argparse
from asyncio.log import logger
import platform
import sys
import os
import time
import re
from datetime import datetime
from data import Data
import logging
from glob import glob

LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
DATE_FORMAT = "%m/%d/%Y %H:%M:%S %p"
logging.basicConfig(filename='runner.log', level=logging.DEBUG, format=LOG_FORMAT, datefmt=DATE_FORMAT)

class Tool:
    def __init__(self):
        pass

    def gen_list(self, data):
        return data.strip().split('\n')

    def get_time_stamp(self):
        return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

class Execute:
    def __init__(self):
        self.cur_time = ''
        self.end_time = ''
        self.tool = Tool()
        self.flags = '*' * 80

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
    def exec_popen(self, cmd):
        self.print_cmd(cmd)
        output = os.popen(cmd).readlines()
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
        state = os.system(cmd)
        self.end_time = self.tool.get_time_stamp()
        if state:
            print(f"failed at {self.end_time}:{state}".upper())
        else:
            print(f"successfully executed at {self.end_time}, congradulations!!!".upper())
        print(f"total time used: {self.get_duration()}s")
        logger.info(cmd)

    def exec_raw(self, rows):
        self.exec_list(self.tool.gen_list(rows))

class Machine:
    def __init__(self):
        self.exe = Execute()
        self.info2cmd = {
            'CHECK network adapter':'nmcli d',
            'CHECK Machine Bits':'getconf LONG_BIT',
            'CHECK OS':'cat /proc/version && uname -a',
            'CHECK GPU': 'lspci | grep -i nvidia',
            'CHECK Total Memory':'cat /proc/meminfo | grep MemTotal',
            'CHECK Total Disk Memory':'fdisk -l | grep Disk',
            'CHECK CPU info': 'cat /proc/cpuinfo | grep "processor" | wc -l && lscpu && dmidecode -t 4'
        }

    def prt_content(self, content):
        flags = '*' * 30
        print(f"{flags}{content}{flags}")

    def get_info(self, content, cmd):
        self.prt_content(content)
        self.exe.exec_raw(cmd)
    
    def output_machine_info(self):
        for key, value in self.info2cmd.items():
            self.get_info(key, value)

class HPCRunner:
    def __init__(self):
        self.hpc_data = Data()
        self.tool = Tool()
        self.exe = Execute()
        self.machine = Machine()
        self.isARM = platform.machine() == 'aarch64'
        self.ARM_path = './software/arm'
        self.X86_path = './software/x86'
        self.ROOT = os.getcwd()
        self.avail_ips_list = self.tool.gen_list(Data.avail_ips)
        self.download_list = self.tool.gen_list(Data.download_urls)

        # Argparser set
        parser = argparse.ArgumentParser(description=f'please put me into CASE directory, used for {Data.app_name} Compiler/Clean/Run/Compare',
                    usage='%(prog)s [-h] [--build] [--clean] [...]')
        parser.add_argument("-v","--version", help=f"get version info", action="store_true")
        parser.add_argument("-use","--use", help="Switch config file...", nargs=1)
        parser.add_argument("-i","--info", help=f"get machine info", action="store_true")
        parser.add_argument("-e","--env", help=f"set environment {Data.app_name}", action="store_true")
        parser.add_argument("-b","--build", help=f"compile {Data.app_name}", action="store_true")
        parser.add_argument("-cls","--clean", help=f"clean {Data.app_name}", action="store_true")
        parser.add_argument("-r","--run", help=f"run {Data.app_name}", action="store_true")
        parser.add_argument("-p","--perf", help=f"auto perf {Data.app_name}", action="store_true")
        # GPU perf
        parser.add_argument("-gp","--gpuperf", help="GPU perf...", action="store_true")

        # NCU perf
        parser.add_argument("-ncu","--ncuperf", help="NCU perf...", nargs=1)
        parser.add_argument("-c","--compare", help=f"compare {Data.app_name}", nargs=2)
        # batch run
        parser.add_argument("-rb","--rbatch", help=f"run batch {Data.app_name}", action="store_true")
        # batch download
        parser.add_argument("-d","--download", help="Batch Download...", action="store_true")
        parser.add_argument("-net","--network", help="network checking...", action="store_true")
        #change yum repo to aliyun
        parser.add_argument("-yum","--yum", help="yum repo changing...", action="store_true")
        self.args = parser.parse_args()

    def write_file(self, filename, content=""):
        with open(filename,'w') as f:
            f.write(content)

    def get_machine_info(self):
        print("get machine info")
        self.machine.output_machine_info()

    def check_network(self):
        print(f"start network checking")
        network_test_cmd='''
wget --spider -T 5 -q -t 2 www.baidu.com | echo $?
curl -s -o /dev/null www.baidu.com | echo $?
    '''
        self.exe.exec_raw(network_test_cmd)

    def env(self):
        print(f"set environment {Data.app_name}")
        self.write_file(Data.env_file, Data.module_content)
        print(f"ENV FILE\n{Data.env_file}\nGENERATED.")
        env_cmd = f'please execute.\n\nsource {Data.env_file}\n'
        print(env_cmd)

    def clean(self):
        print(f"start clean {Data.app_name}")
        clean_cmd=self.hpc_data.get_clean_cmd()
        self.exe.exec_raw(clean_cmd)

    def build(self):
        print(f"start build {Data.app_name}")
        build_cmd = self.hpc_data.get_build_cmd()
        self.exe.exec_raw(build_cmd)

    def gen_hostfile(self, nodes):
        length = len(self.avail_ips_list)
        if nodes > length:
            print(f"You don't have {nodes} nodes, only {length} nodes available!")
            sys.exit()
        if nodes <= 1:
            return
        gen_nodes = '\n'.join(self.avail_ips_list[:nodes])
        print(f"HOSTFILE\n{gen_nodes}\nGENERATED.")
        self.write_file('hostfile', gen_nodes)

    # single run
    def run(self):
        print(f"start run {Data.app_name}")
        nodes = int(Data.run_cmd['nodes'])
        self.gen_hostfile(nodes)
        run_cmd = self.hpc_data.get_run_cmd()
        self.exe.exec_raw(run_cmd)

    def batch_run(self):
        batch_file = 'Batch_run.sh'
        print(f"start batch run {Data.app_name}")
        batch_content = f'''
cd {Data.case_dir}
{Data.batch_cmd}
'''
        with open(batch_file, 'w') as f:
            f.write(batch_content)
        run_cmd = f'''
chmod +x {batch_file}
./{batch_file}
'''
        self.exe.exec_raw(run_cmd)

    def change_yum_repo(self):
        print(f"start yum repo change")
        repo_cmd = '''
cp ./config/yum/*.repo /etc/yum.repos.d/  
yum clean all
yum makecache
'''
        self.exe.exec_raw(repo_cmd)

    def get_pid(self):
        #get pid
        pid_cmd = f'pidof {Data.binary_file}'
        result = self.exe.exec_popen(pid_cmd)
        if len(result) == 0:
            print("failed to get pid.")
            sys.exit()
        else:
            pid_list = result[0].split(' ')
        return pid_list[0].strip()

    def perf(self):
        print(f"start perf {Data.app_name}")
        #get pid
        pid = self.get_pid()
        #start perf && analysis
        perf_cmd = f'''
perf record -a -g -p {pid}
perf report  -i perf.data -F period,sample,overhead,symbol,dso,comm -s overhead --percent-limit 0.1% --stdio
'''
        self.exe.exec_raw(perf_cmd)

    def gen_wget_url(self, out_dir='./downloads', url=''):
        head = "wget --no-check-certificate"
        out_para = "-P"
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)
        download_url = f'{head} {out_para} {out_dir} {url}'
        return download_url

    def download(self):
        print(f"start download")
        for url in self.download_list:
            download_url = self.gen_wget_url(url=url)
            os.popen(download_url)

    def get_arch(self):
        arch = 'arm'
        if not self.isARM:
            arch = 'X86'
        return arch

    def get_cur_time(self):
        return re.sub(' |:', '-', self.tool.get_time_stamp())

    def gpu_perf(self):
        print(f"start gpu perf")
        run_cmd = self.hpc_data.get_run()
        gperf_cmd = f'''
cd {Data.case_dir}
nsys profile -y 5s -d 100s -o nsys-{self.get_arch()}-{self.get_cur_time()} {run_cmd}
    '''
        self.exe.exec_raw(gperf_cmd)

    def ncu_perf(self, kernel):
        print(f"start ncu perf")
        run_cmd = self.hpc_data.get_run()
        ncu_cmd = f'''
    cd {Data.case_dir}
    ncu --export ncu-{self.get_arch()}-{self.get_cur_time()} --import-source=yes --set full --kernel-name {kernel} --launch-skip 1735 --launch-count 1 {run_cmd}
    '''
        self.exe.exec_raw(ncu_cmd)

    def switch_config(self, config_file):
        print(f"Switch config file to {config_file}")
        with open(Data.meta_file, 'w') as f:
            f.write(config_file.strip())
        print("Successfully switched.")
    
    def main(self):
        if self.args.version:
            print("V1.0")
        
        if self.args.info:
            self.get_machine_info()

        if self.args.env:
            self.env()

        if self.args.clean:
            self.clean()

        if self.args.build:
            self.build()

        if self.args.run:
            self.run()

        if self.args.perf:
            self.perf()

        if self.args.rbatch:
            self.batch_run()

        if self.args.download:
            self.download()

        if self.args.gpuperf:
            self.gpu_perf()
        
        if self.args.ncuperf:
            self.ncu_perf(self.args.ncuperf[0])
        
        if self.args.use:
            self.switch_config(self.args.use[0])
        
        if self.args.network:
            self.check_network()

        if self.args.yum:
            self.change_yum_repo()
        
        data_list = self.args.compare
        if data_list and len(data_list) == 2:
            print(f"start compare {Data.app_name}")
            self.compare(data_list[0], data_list[1])
        
if __name__ == '__main__':
    HPCRunner().main()
