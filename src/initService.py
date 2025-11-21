#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os

from executeService import ExecuteService

class Singleton(type):
    def __init__(self, name, bases, dictItem):
        super(Singleton,self).__init__(name,bases, dictItem)
        self._instance = None

    def __call__(self, *args, **kwargs):
        if self._instance is None:
            self._instance = super(Singleton,self).__call__(*args, **kwargs)
        return self._instance

class InitService(object,metaclass=Singleton):
    INIT_FILE = 'init.sh'
    def __init__(self):
        self.exe = ExecuteService()
        self.init_jarvis()
    
    def jarvis_activation(self) -> str:
        """环境激活命令 (模板方法)"""
        return f'source ./{self.INIT_FILE}'

    def init_jarvis(self):
        init_cmd = self.jarvis_activation()
        self.exe.exec_inject(init_cmd)
        print("JARVIS IS READY ^_^")



