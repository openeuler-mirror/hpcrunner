#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import time
import os

class Tool:
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
        with open(filename, encoding='utf-8') as f:
            content = f.read().strip()
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
