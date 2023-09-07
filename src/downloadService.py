#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService

class DownloadService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.download_list = self.tool.gen_list(DataService.download_info)
        self.download_path = os.path.join(self.ROOT, 'downloads')
        self.package_path = os.path.join(self.ROOT, 'package')

    def check_network(self):
        print(f"start network checking")
        network_test_cmd='''
wget --spider -T 5 -q -t 2 www.baidu.com | echo $?
curl -s -o /dev/null www.baidu.com | echo $?
    '''
        self.exe.exec_raw(network_test_cmd)

    def change_yum_repo(self):
        print(f"start yum repo change")
        repo_cmd = '''
cp ./templates/yum/*.repo /etc/yum.repos.d/
yum clean all
yum makecache
'''
        self.exe.exec_raw(repo_cmd)

    def gen_wget_url(self, out_dir='./downloads', url='', filename=''):
        head = "wget --no-check-certificate"
        file_path = os.path.join(out_dir, filename)
        download_url = f'{head} {url} -O {file_path}'
        return download_url

    def download(self):
        print(f"start download")
        filename_url_map = {}
        self.tool.mkdirs(self.download_path)
        download_flag = False
        # create directory
        for url_info in self.download_list:
            url_list = url_info.split(' ')
            if len(url_list) < 2:
                continue
            url_link = url_list[1].strip()
            filename = os.path.basename(url_link)
            if len(url_list) == 3:
                filename = url_list[2].strip()
            filename_url_map[filename] = url_link
            
        print(filename_url_map)
        # start download
        for filename, url in filename_url_map.items():
            download_flag = True
            file_path = os.path.join(self.download_path, filename)
            if os.path.exists(file_path):
                self.tool.prt_content(f"FILE {filename} already DOWNLOADED")
                continue
            download_url = self.gen_wget_url(self.download_path, url, filename)
            self.tool.prt_content("DOWNLOAD " + filename)
            with os.popen(download_url) as p:
                data = p.read()


        if not download_flag:
            print("The download list is empty!")
