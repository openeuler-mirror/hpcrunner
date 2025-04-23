#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import argparse
from initService import InitService
from dataService import DataService
from analysisService import AnalysisService

class Jarvis:
    def __init__(self):
        self.init = InitService()
        self.analysis = AnalysisService()
        self.ds = DataService()
        self.app_name = self.ds.get_app_name()
        # Argparser set
        parser = argparse.ArgumentParser(description=f'please put me into CASE directory, used for {self.app_name} Compiler/Clean/Run/Compare',
                    usage='%(prog)s [-h] [--build] [--clean] [...]')
        parser.add_argument("-v","--version", help=f"get version info", action="store_true")
        parser.add_argument("-use","--use", help="Switch config file...", nargs=1)
        parser.add_argument("-i","--info", help=f"get machine info", action="store_true")
        parser.add_argument("-l","--list", help=f"get installed package info", action="store_true")
        parser.add_argument("-loop","--loop", help=f"get loop simulation code", action="store_true")
        #accept software_name/version GCC/GCC+MPI/CLANG/CLANG+MPI
        parser.add_argument("-install","--install", help=f"install dependency", nargs='+')
        #remove
        parser.add_argument("-remove","--remove", help=f"remove software", nargs=1)
        #find
        parser.add_argument("-find","--find", help=f"find software", nargs=1)
        # dependency install
        parser.add_argument("-dp","--depend", help=f"{self.app_name} dependency install", action="store_true")
        parser.add_argument("-e","--env", help=f"set environment {self.app_name}", action="store_true")
        parser.add_argument("-b","--build", help=f"compile {self.app_name}", action="store_true")
        parser.add_argument("-cls","--clean", help=f"clean {self.app_name}", action="store_true")
        parser.add_argument("-r","--run", help=f"run {self.app_name}", action="store_true")
        parser.add_argument("-j","--job", help=f"run job {self.app_name}", action="store_true")
        parser.add_argument("-j2","--job2", help=f"run job 2 {self.app_name}", action="store_true")
        parser.add_argument("-p","--perf", help=f"auto perf {self.app_name}", action="store_true")
        parser.add_argument("-kp","--kperf", help=f"auto kperf {self.app_name}", action="store_true")
        # GPU perf
        parser.add_argument("-gp","--gpuperf", help="GPU perf...", action="store_true")
        # hpctool perf
        parser.add_argument("-hpctool","--hpctool", help="hpctool perf...", action="store_true")

        # NCU perf
        parser.add_argument("-ncu","--ncuperf", help="NCU perf...", nargs=1)
        parser.add_argument("-c","--compare", help=f"compare {self.app_name}", nargs=2)
        # batch run
        parser.add_argument("-rb","--rbatch", help=f"run batch {self.app_name}", action="store_true")
        # batch download
        parser.add_argument("-d","--download", help="Batch Download...", action="store_true")
        # generate singularity def file
        parser.add_argument("-container","--container", help="generate container file...", nargs=1)
        parser.add_argument("-net","--network", help="network checking...", action="store_true")
        #change yum repo to aliyun
        parser.add_argument("-yum","--yum", help="yum repo changing...", action="store_true")
        # start benchmark test
        parser.add_argument("-bench","--benchmark", help="start benchmark test...", nargs=1)
        # start test
        parser.add_argument("-t","--test", help="start Jarvis test...", action="store_true")
        # start Roce
        parser.add_argument("-R","--roce", help="start roce run...", nargs=2)
        # update modulefile path when hpcrunner is moved
        parser.add_argument("-u","--update", help="start update jarvis...", action="store_true")
        # check download url is good or not
        parser.add_argument("-check","--check", help="start check jarvis download url...", action="store_true")
        self.args = parser.parse_args()

    def main(self):
        if self.args.version:
            print("V1.0")
        
        if self.args.info:
            self.analysis.get_machine_info()

        if self.args.list:
            self.analysis.get_install_list()

        if self.args.download:
            self.analysis.download()
        
        if self.args.depend:
            self.analysis.install_deps()

        if self.args.install:
            self.analysis.install(self.args.install)
        
        if self.args.remove:
            self.analysis.remove(self.args.remove[0])
        
        if self.args.find:
            self.analysis.find(self.args.find[0])
        
        if self.args.env:
            self.analysis.env()

        if self.args.clean:
            self.analysis.clean()

        if self.args.build:
            self.analysis.build()

        if self.args.job:
            self.analysis.job_run()

        if self.args.job2:
            self.analysis.job2_run()

        if self.args.run:
            self.analysis.run()

        if self.args.perf:
            self.analysis.perf()

        if self.args.kperf:
            self.analysis.kperf()

        if self.args.rbatch:
            self.analysis.batch_run()

        if self.args.gpuperf:
            self.analysis.gpu_perf()
        
        if self.args.hpctool:
            self.analysis.hpctool_perf()
        
        if self.args.ncuperf:
            self.analysis.ncu_perf(self.args.ncuperf[0])
        
        if self.args.container:
            self.analysis.gen_def(self.args.container[0])
        
        if self.args.use:
            self.analysis.switch_config(self.args.use[0])
        
        if self.args.network:
            self.analysis.check_network()

        if self.args.yum:
            self.analysis.change_yum_repo()
        
        if self.args.benchmark:
            self.analysis.bench(self.args.benchmark[0])
        
        if self.args.test:
            self.analysis.test()
            
        if self.args.roce:
            self.analysis.get_roceinfo(self.args.roce[0],self.args.roce[1])
        
        if self.args.update:
            self.analysis.update()
        
        if self.args.loop:
            self.analysis.gen_simucode()
        
        if self.args.check:
            self.analysis.check_download_url()
        
if __name__ == '__main__':
    Jarvis().main()
