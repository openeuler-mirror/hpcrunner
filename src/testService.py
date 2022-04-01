#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
from executeService import ExecuteService

class TestService:
    def __init__(self):
        self.exe = ExecuteService()
        self.ROOT = os.getcwd()
        self.test_dir = os.path.join(self.ROOT, 'test')

    def test(self):
        run_cmd = f'''
cd {self.test_dir}
./test-qe.sh
cd {self.test_dir}
./test-util.sh
'''
        self.exe.exec_raw(run_cmd)

