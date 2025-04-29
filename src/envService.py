#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os

from commandBuilder import CommandBuilder
from executeService import ExecuteService
from dataService import DataService

class Singleton(type):
    def __init__(self, name, bases, dictItem):
        super(Singleton,self).__init__(name,bases, dictItem)
        self._instance = None

    def __call__(self, *args, **kwargs):
        if self._instance is None:
            self._instance = super(Singleton,self).__call__(*args, **kwargs)
        return self._instance

class EnvService(object,metaclass=Singleton):
    def __init__(self):
        self.command = CommandBuilder()  # 注入命令生成组件
        self.exe = ExecuteService()
        self.ds = DataService()

    def env(self):
        print(f"set environment...{self.ds.get_app_name()}")
        env_cmd = self.command.env_generate()
        self.exe.exec_raw(env_cmd)
