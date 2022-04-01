#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import argparse

from dataService import DataService
from analysisService import AnalysisService

class Jarvis:
    def __init__(self):
        self.analysis = AnalysisService()
        # Argparser set
        parser = argparse.ArgumentParser(description=f'please put me into CASE directory, used for {DataService.app_name} Compiler/Clean/Run/Compare',
                    usage='%(prog)s [-h] [--build] [--clean] [...]')
        parser.add_argument("-v","--version", help=f"get version info", action="store_true")
        parser.add_argument("-use","--use", help="Switch config file...", nargs=1)
        parser.add_argument("-i","--info", help=f"get machine info", action="store_true")
        #accept software_name/version GCC/GCC+MPI/CLANG/CLANG+MPI
        parser.add_argument("-install","--install", help=f"install dependency", nargs=2)
        # dependency install
        parser.add_argument("-dp","--depend", help=f"{DataService.app_name} dependency install", action="store_true")
        parser.add_argument("-e","--env", help=f"set environment {DataService.app_name}", action="store_true")
        parser.add_argument("-b","--build", help=f"compile {DataService.app_name}", action="store_true")
        parser.add_argument("-cls","--clean", help=f"clean {DataService.app_name}", action="store_true")
        parser.add_argument("-r","--run", help=f"run {DataService.app_name}", action="store_true")
        parser.add_argument("-p","--perf", help=f"auto perf {DataService.app_name}", action="store_true")
        parser.add_argument("-kp","--kperf", help=f"auto kperf {DataService.app_name}", action="store_true")
        # GPU perf
        parser.add_argument("-gp","--gpuperf", help="GPU perf...", action="store_true")

        # NCU perf
        parser.add_argument("-ncu","--ncuperf", help="NCU perf...", nargs=1)
        parser.add_argument("-c","--compare", help=f"compare {DataService.app_name}", nargs=2)
        # batch run
        parser.add_argument("-rb","--rbatch", help=f"run batch {DataService.app_name}", action="store_true")
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
        self.args = parser.parse_args()

    def main(self):
        if self.args.version:
            print("V1.0")
        
        if self.args.info:
            self.analysis.get_machine_info()

        if self.args.install:
            self.analysis.install(self.args.install[0], self.args.install[1])

        if self.args.env:
            self.analysis.env()

        if self.args.clean:
            self.analysis.clean()

        if self.args.build:
            self.analysis.build()

        if self.args.run:
            self.analysis.run()

        if self.args.perf:
            self.analysis.perf()

        if self.args.kperf:
            self.analysis.kperf()

        if self.args.depend:
            self.analysis.install_deps()

        if self.args.rbatch:
            self.analysis.batch_run()

        if self.args.download:
            self.analysis.download()

        if self.args.gpuperf:
            self.analysis.gpu_perf()
        
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
        
if __name__ == '__main__':
    Jarvis().main()
