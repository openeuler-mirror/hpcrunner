#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

from machineService import MachineService
from configService import ConfigService
from downloadService import DownloadService
from installService import InstallService
from envService import EnvService
from buildService import BuildService
from runService import RunService
from perfService import PerfService
from testService import TestService
from benchService import BenchmarkService
from containerService import ContainerService

class AnalysisService:
    def __init__(self):
        self.jmachine = MachineService()
        self.jconfig = ConfigService()
        self.jdownload = DownloadService()
        self.jinstall = InstallService()
        self.jenv = EnvService()
        self.jbuild = BuildService()
        self.jrun = RunService()
        self.jperf = PerfService()
        self.jbenchmark = BenchmarkService()
        self.jcontainer = ContainerService()
        self.jtest = TestService()

    def get_machine_info(self):
        self.jmachine.output_machine_info()

    def bench(self, bench_case):
        self.jbenchmark.output_bench_info(bench_case)

    def switch_config(self, config_file):
        self.jconfig.switch_config(config_file)

    def test(self):
        self.jtest.test()

    def download(self):
        self.jdownload.download()

    def check_network(self):
        self.jdownload.check_network()

    def gpu_perf(self):
        self.jperf.gpu_perf()
    
    def ncu_perf(self, kernel):
        self.jperf.ncu_perf(kernel)

    def perf(self):
        self.jperf.perf()

    def kperf(self):
        self.jperf.kperf()
    
    def run(self):
        self.jrun.run()
    
    def batch_run(self):
        self.jrun.batch_run()

    def clean(self):
        self.jbuild.clean()
    
    def build(self):
        self.jbuild.build()

    def env(self):
        self.jenv.env()
    
    def install(self,software_path, compiler_mpi_info):
        self.jinstall.install(software_path, compiler_mpi_info)
    
    def get_install_list(self):
        self.jinstall.list()
    
    def remove(self,software_path):
        self.jinstall.remove(software_path)

    def find(self,content):
        self.jinstall.find(content)
    
    def install_deps(self):
        self.jinstall.install_depend()
    
    def gen_def(self, image):
        self.jcontainer.gen_def(image)
