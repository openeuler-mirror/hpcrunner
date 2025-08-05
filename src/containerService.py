#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
from toolService import ToolService
from dataService import DataService

class ContainerService:
    def __init__(self):
        self.tool = ToolService()
        self.data = DataService()
    
    def gen_def(self, image):
        config_file = self.data.get_config_file_name()
        def_file_content = f'''BootStrap: docker
From: {image}

%environment
    source /etc/profile || true
    cd $JARVIS_ROOT
    source env.sh

%post
    # Install the necessary development environment
    yum install -y environment-modules git dmidecode pciutils wget vim
    # Install base gcc
    yum install -y gcc gcc-c++ gcc-gfortran glibc-devel make libgfortran
    # install network package
    yum install -y tcsh tcl lsof tk bc 
    source /etc/profile || true
    git config --global http.sslVerify false
    git clone https://gitee.com/openeuler/hpcrunner
    cd hpcrunner
    source ./init.sh
    # add your personal files here
    
    # Switch config
    ./jarvis -use {config_file}
    # download dependency
    ./jarvis -d
    # install dependency
    ./jarvis -dp
    # build hpc
    ./jarvis -b
    # run hpc
    ./jarvis -r
    # clean tmp directory
    rm -rf downloads tmp
'''
        def_file = config_file+'.def'
        self.tool.write_file(def_file, def_file_content)
        print(f'Singularity file {def_file} successfully generated!')
