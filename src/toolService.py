#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import time
import os


class ToolService:
    def __init__(self):
        pass
    
    def prt_content(self, content):
        flags = '*' * 30
        print(f"{flags}{content}{flags}")

    def gen_list(self, data):
        return data.strip().split('\n')

    def get_time_stamp(self):
        return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    
    def read_file(self, filename):
        content = ''
        try:
            with open(filename, encoding='utf-8') as f:
                content = f.read().strip()
        except IOError:
            return content
        return content
    
    def write_file(self, filename, content=""):
        with open(filename,'w') as f:
            f.write(content)
    
    def mkdirs(self, path):
        if not os.path.exists(path):
            os.makedirs(path)
    
    def mkfile(self, path, content=''):
        if not os.path.exists(path):
            self.write_file(path, content)

    def check_url_isvalid(self,url):
        import requests
        try:
            response = requests.get(url, stream=True)
            if response.status_code == 200:
                return True
            else:
                return False
        except requests.exceptions.RequestException as e:
            return False