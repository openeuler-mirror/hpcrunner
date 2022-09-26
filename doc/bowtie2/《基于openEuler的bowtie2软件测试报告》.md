# 《基于openEuler的Bowtie2软件测试报告》

## 1.规范性自检

项目使用了Artistic Style对文件进行格式化

AStyle，即Artistic Style，是一个可用于C, C++, C++/CLI, Objective‑C, C# 和Java编程语言格式化和美化的工具。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`config/bowtie2.astylerc`，文件内容如下

```astylerc
# Bowtie2 formatting options for Artistic Style
--style=allman
--indent=spaces=3
--keep-one-line-statements
--keep-one-line-blocks
--pad-header
--max-code-length=80
--max-instatement-indent=80
--min-conditional-indent=0
--indent-col1-comments
--indent-labels
--break-after-logical
--add-brackets
--indent-switches
--convert-tabs
--lineend=linux
--suffix=none
--preserve-date
--formatted
```

对于当前项目，检查代码规范性，可以通过使用AStyle对所有源码进行重新格式化，然后使用git查看文件修改。

统计代码不规范内容。

## 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```python
# -*- coding: utf-8 -*-

import os

print (os.getcwd())

def getAllFiles(targetDir):
    files = []
    listFiles = os.listdir(targetDir)
    for i in range(0, len(listFiles)):
        path = os.path.join(targetDir, listFiles[i])
        if os.path.isdir(path):
            files.extend(getAllFiles(path))
        elif os.path.isfile(path):
            files.append(path)
    return files

all_files=getAllFiles(os.curdir)
type_dict=dict()

for each_file in all_files:
    if os.path.isdir(each_file):
        type_dict.setdefault("文件夹",0)
        type_dict["文件夹"]+=1
    else:
        ext=os.path.splitext(each_file)[1]
        type_dict.setdefault(ext,0)
        type_dict[ext]+=1

for each_type in type_dict.keys():
    print ("当前文件夹下共有【%s】的文件%d个" %(each_type,type_dict[each_type]))
```


在bowtie2项目根目录下运行,运行结果如下

```bash
[root@ecs-7567 bowtie2]# python main.py 
/root/bowtie2
当前文件夹下共有【】的文件25个
当前文件夹下共有【.pl】的文件8个
当前文件夹下共有【.md】的文件2个
当前文件夹下共有【.py】的文件10个
当前文件夹下共有【.cpp】的文件58个
当前文件夹下共有【.idx】的文件1个
当前文件夹下共有【.bam】的文件1个
当前文件夹下共有【.fa】的文件3个
当前文件夹下共有【.sample】的文件11个
当前文件夹下共有【.gif】的文件1个
当前文件夹下共有【.yml】的文件2个
当前文件夹下共有【.fq】的文件3个
当前文件夹下共有【.sh】的文件22个
当前文件夹下共有【.pack】的文件1个
当前文件夹下共有【.bench】的文件1个
当前文件夹下共有【.pm】的文件9个
当前文件夹下共有【.markdown】的文件1个
当前文件夹下共有【.bt2】的文件6个
当前文件夹下共有【.h】的文件75个
当前文件夹下共有【.png】的文件3个
当前文件夹下共有【.shtml】的文件5个
当前文件夹下共有【.ssi】的文件7个
当前文件夹下共有【.json】的文件2个
当前文件夹下共有【.css】的文件1个
当前文件夹下共有【.txt】的文件2个
当前文件夹下共有【.html】的文件2个
当前文件夹下共有【.html】的文件2个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`h`.

## 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.h\|.*\.cpp" | xargs wc -l
```

统计结果

```bash
  84788 total
```

## 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`,`c`, 的所有文件进行格式

```bash
[root@ecs-7567 bowtie2]# astyle --project=config/bowtie2.astylerc -R ./*.cpp,*.h -v
Artistic Style 3.1                                09/25/2022
Project option file  /root/bowtie2/config/bowtie2.astylerc
------------------------------------------------------------
Directory  ./*.cpp,*.h
------------------------------------------------------------
Formatted  aligner_bt.cpp
Formatted  aligner_bt.h
Formatted  aligner_cache.cpp
Formatted  aligner_cache.h
Formatted  aligner_driver.cpp
Formatted  aligner_driver.h
Formatted  aligner_metrics.h
Formatted  aligner_report.h
Formatted  aligner_result.cpp
Formatted  aligner_result.h
Formatted  aligner_seed.cpp
Formatted  aligner_seed.h
Formatted  aligner_seed2.cpp
Formatted  aligner_seed2.h
Formatted  aligner_seed_policy.cpp
Formatted  aligner_seed_policy.h
Formatted  aligner_sw.cpp
Formatted  aligner_sw.h
Formatted  aligner_sw_common.h
Formatted  aligner_sw_driver.cpp
Formatted  aligner_sw_driver.h
Formatted  aligner_sw_nuc.h
Formatted  aligner_swsse.cpp
Formatted  aligner_swsse.h
Formatted  aligner_swsse_ee_i16.cpp
Formatted  aligner_swsse_ee_u8.cpp
Formatted  aligner_swsse_loc_i16.cpp
Formatted  aligner_swsse_loc_u8.cpp
Formatted  aln_sink.cpp
Formatted  aln_sink.h
Formatted  alphabet.cpp
Formatted  alphabet.h
Formatted  assert_helpers.h
Formatted  banded.cpp
Formatted  banded.h
Formatted  binary_sa_search.h
Formatted  bitpack.h
Formatted  blockwise_sa.h
Formatted  bowtie_build_main.cpp
Formatted  bowtie_main.cpp
Formatted  bt2_build.cpp
Formatted  bt2_dp.cpp
Formatted  bt2_idx.cpp
Formatted  bt2_idx.h
Formatted  bt2_inspect.cpp
Formatted  bt2_io.cpp
Formatted  bt2_locks.cpp
Formatted  bt2_locks.h
Formatted  bt2_search.cpp
Formatted  bt2_search.h
Formatted  bt2_util.cpp
Formatted  btypes.h
Formatted  ccnt_lut.cpp
Formatted  cpu_numa_info.cpp
Formatted  diff_sample.cpp
Formatted  diff_sample.h
Formatted  dp_framer.cpp
Formatted  dp_framer.h
Formatted  ds.cpp
Formatted  ds.h
Formatted  edit.cpp
Formatted  edit.h
Formatted  endian_swap.h
Formatted  fast_mutex.h
Formatted  filebuf.h
Formatted  formats.h
Formatted  group_walk.h
Formatted  ival_list.cpp
Formatted  ival_list.h
Formatted  ls.cpp
Formatted  ls.h
Formatted  mask.cpp
Formatted  mask.h
Formatted  multikey_qsort.h
Formatted  opts.h
Formatted  outq.cpp
Formatted  outq.h
Formatted  pat.cpp
Formatted  pat.h
Formatted  pe.cpp
Formatted  pe.h
Formatted  presets.cpp
Formatted  presets.h
Formatted  processor_support.h
Formatted  qual.cpp
Formatted  qual.h
Formatted  random_source.cpp
Formatted  random_source.h
Formatted  random_util.h
Formatted  read.h
Formatted  read_qseq.cpp
Formatted  ref_coord.cpp
Formatted  ref_coord.h
Formatted  ref_read.cpp
Formatted  ref_read.h
Formatted  reference.cpp
Formatted  reference.h
Formatted  sam.cpp
Formatted  sam.h
Formatted  scoring.cpp
Formatted  scoring.h
Formatted  sequence_io.h
Formatted  shmem.cpp
Formatted  shmem.h
Formatted  simple_func.cpp
Formatted  simple_func.h
Formatted  sse_util.cpp
Formatted  sse_util.h
Formatted  sstring.cpp
Formatted  sstring.h
Formatted  str_util.h
Formatted  threading.h
Formatted  threadpool.h
Formatted  timer.h
Formatted  tokenize.h
Formatted  unique.cpp
Formatted  unique.h
Formatted  util.h
Formatted  word_io.h
Formatted  zbox.h
Formatted  zstd_decompress.cpp
Formatted  zstd_decompress.h
Formatted  third_party/cpuid.h
------------------------------------------------------------
 123 formatted   10 unchanged   0.46 seconds   94,241 lines
```

使用git 对文件格式化修改内容进行统计

```
[root@ecs-7567 bowtie2]# git commit -m "fomat update"
[master 1a8f07f] fomat update
 125 files changed, 92211 insertions(+), 82842 deletions(-)
 rewrite aligner_bt.cpp (92%)
 rewrite aligner_bt.h (70%)
 rewrite aligner_cache.cpp (77%)
 rewrite aligner_cache.h (81%)
 rewrite aligner_driver.cpp (89%)
 rewrite aligner_metrics.h (88%)
 rewrite aligner_result.cpp (88%)
 rewrite aligner_result.h (89%)
 rewrite aligner_seed.cpp (89%)
 rewrite aligner_seed.h (90%)
 rewrite aligner_seed2.cpp (93%)
 rewrite aligner_seed2.h (82%)
 rewrite aligner_seed_policy.cpp (74%)
 rewrite aligner_seed_policy.h (83%)
 rewrite aligner_sw.cpp (93%)
 rewrite aligner_sw.h (71%)
 rewrite aligner_sw_common.h (80%)
 rewrite aligner_sw_driver.cpp (89%)
 rewrite aligner_sw_driver.h (78%)
 rewrite aligner_sw_nuc.h (75%)
 rewrite aligner_swsse.h (78%)
 rewrite aligner_swsse_ee_i16.cpp (87%)
 rewrite aligner_swsse_ee_u8.cpp (87%)
 rewrite aligner_swsse_loc_i16.cpp (87%)
 rewrite aligner_swsse_loc_u8.cpp (86%)
 rewrite aln_sink.cpp (88%)
 rewrite aln_sink.h (82%)
 rewrite alphabet.cpp (77%)
 rewrite assert_helpers.h (65%)
 rewrite blockwise_sa.h (88%)
 rewrite bt2_build.cpp (87%)
 rewrite bt2_dp.cpp (84%)
 rewrite bt2_idx.cpp (67%)
 rewrite bt2_idx.h (90%)
 rewrite bt2_inspect.cpp (82%)
 rewrite bt2_io.cpp (88%)
 rewrite bt2_locks.cpp (95%)
 rewrite bt2_locks.h (76%)
 rewrite bt2_search.cpp (89%)
 rewrite bt2_util.cpp (72%)
 rewrite ccnt_lut.cpp (94%)
 create mode 100644 config/bowtie2.astylerc
 rewrite diff_sample.h (82%)
 rewrite dp_framer.cpp (75%)
 rewrite dp_framer.h (74%)
 rewrite ds.cpp (68%)
 rewrite ds.h (88%)
 rewrite edit.cpp (74%)
 rewrite edit.h (77%)
 rewrite filebuf.h (87%)
 rewrite group_walk.h (85%)
 rewrite ival_list.cpp (82%)
 rewrite ival_list.h (80%)
 rewrite ls.cpp (75%)
 rewrite ls.h (86%)
 create mode 100644 main.py
 rewrite multikey_qsort.h (74%)
 rewrite opts.h (88%)
 rewrite outq.cpp (81%)
 rewrite outq.h (67%)
 rewrite pat.cpp (86%)
 rewrite pat.h (84%)
 rewrite pe.cpp (91%)
 rewrite pe.h (77%)
 rewrite presets.cpp (71%)
 rewrite qual.cpp (74%)
 rewrite qual.h (64%)
 rewrite random_source.cpp (72%)
 rewrite random_source.h (78%)
 rewrite random_util.h (82%)
 rewrite read.h (86%)
 rewrite read_qseq.cpp (79%)
 rewrite ref_coord.h (85%)
 rewrite ref_read.cpp (81%)
 rewrite ref_read.h (77%)
 rewrite reference.cpp (88%)
 rewrite reference.h (64%)
 rewrite sam.cpp (92%)
 rewrite sam.h (91%)
 rewrite scoring.cpp (75%)
 rewrite scoring.h (77%)
 rewrite sequence_io.h (60%)
 rewrite shmem.h (61%)
 rewrite simple_func.cpp (63%)
 rewrite sse_util.h (92%)
 rewrite sstring.cpp (83%)
 rewrite sstring.h (89%)
 rewrite threading.h (62%)
 rewrite threadpool.h (90%)
 rewrite timer.h (62%)
 rewrite unique.h (81%)
 rewrite zstd_decompress.cpp (87%)
```

## 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 94.5%          1-125/84788*100%

不通过率: 5.5  %           125/84788*100%

## 2.功能性测试

### 2.1.所选测试案例

bowtie2在Makefile中内置两条测试命令，分别是simple-test和random-test，这里选取random-test。

random-test的测试命令如下：
```bash
eval `perl -I $(CURDIR)/.tmp/lib/perl5 -Mlocal::lib=$(CURDIR)/.tmp` ; \
sh ./scripts/sim/run.sh $(if $(NUM_CORES), $(NUM_CORES), 2)

## run.sh
CPUS=$1
shift

MAKE=`which gmake || which make`
$MAKE -j$CPUS \
	bowtie2-align-s \
	bowtie2-align-l \
	bowtie2-align-s-debug \
	bowtie2-align-l-debug \
	bowtie2-build-s \
	bowtie2-build-l \
	bowtie2-build-s-debug \
	bowtie2-build-l-debug && \
perl scripts/sim/run.pl \
	--bowtie2=./bowtie2 \
	--bowtie2-build=./bowtie2-build \
	--cpus=$CPUS \
	$*
```

在项目根目录下执行命令来进行测试
```bash
export NUM_CORES=1
make random-test
```

### 2.2.运行结果
```bash
[root@ecs-7567 bowtie2-2.4.5]# make random-test
if [ ! -d "/root/hpcrunner/tmp/bowtie2-2.4.5/.tmp" ]; then \
	mkdir -p /root/hpcrunner/tmp/bowtie2-2.4.5/.tmp/include /root/hpcrunner/tmp/bowtie2-2.4.5/.tmp/lib ; \
fi
DL=$( ( which wget >/dev/null 2>&1 && echo "wget --no-check-certificate -O-" ) || echo "curl -L") ; \
$DL http://cpanmin.us | perl - -l /root/hpcrunner/tmp/bowtie2-2.4.5/.tmp App::cpanminus local::lib ; \
eval `perl -I /root/hpcrunner/tmp/bowtie2-2.4.5/.tmp/lib/perl5 -Mlocal::lib=/root/hpcrunner/tmp/bowtie2-2.4.5/.tmp` ; \
/root/hpcrunner/tmp/bowtie2-2.4.5/.tmp/bin/cpanm --force File::Which Math::Random Clone Test::Deep Sys::Info ; \
......
Created DNA generator
  N frac: 0.031
  IUPAC frac: 0.008
  AT/ACGT frac: 0.508
  A/AT frac: 0.526
  C/CG frac: 0.296
Generating 2 references
Created DNA generator
  N frac: 0.031
  IUPAC frac: 0.008
  AT/ACGT frac: 0.508
  A/AT frac: 0.526
  C/CG frac: 0.296
Generating 2 references
  Generated reference 'Sim.pm.1' of untrimmed length 308, trimmed length 276
  Generated reference 'Sim.pm.1' of untrimmed length 308, trimmed length 197
  Generated reference 'Sim.pm.2' of untrimmed length 364, trimmed length 85
Wrote references to /tmp/Sim.pm.A3VQFNcf.fa
  A: 87
  B: 1
  C: 61
  G: 123
  N: 7
  T: 81
  V: 1
......
170 reads; of these:
  170 (100.00%) were unpaired; of these:
    170 (100.00%) aligned 0 times
    0 (0.00%) aligned exactly 1 time
    0 (0.00%) aligned >1 times
0.00% overall alignment rate
diff -uw /tmp/Sim.pm.q2WhGHCp.als /tmp/Sim.pm.q2WhGHCp.debug.als
ALSO checking that bowtie2 and bowtie2 -p X w/ X > 1 match up
./bowtie2  --mm --large-index --cp-ival 1 --local --score-min L,7.34249013574406,1.76331087522275 --rfg 19.2968780660232,11.9325479307522 --cp-min 2 -q -p 3 -x /tmp/Sim.pm.q2WhGHCp /tmp/Sim.pm.q2WhGHCp_1.fastq | grep -v '^@PG' > /tmp/Sim.pm.q2WhGHCp.px.als
Warning: skipping read '5' because length (1) <= # seed mismatches (0)
Warning: skipping read '5' because it was < 2 characters long
Warning: skipping read '41' because length (1) <= # seed mismatches (0)
Warning: skipping read '41' because it was < 2 characters long
Warning: skipping read '157' because length (1) <= # seed mismatches (0)
Warning: skipping read '157' because it was < 2 characters long
170 reads; of these:
  170 (100.00%) were unpaired; of these:
    170 (100.00%) aligned 0 times
    0 (0.00%) aligned exactly 1 time
    0 (0.00%) aligned >1 times
0.00% overall alignment rate
sort -k 1,1 -n -k 2,2 -k 3,3 -k 4,4 < /tmp/Sim.pm.q2WhGHCp.px.als | grep -v '^@PG' > /tmp/Sim.pm.q2WhGHCp.px.als.sorted
sort -k 1,1 -n -k 2,2 -k 3,3 -k 4,4 < /tmp/Sim.pm.q2WhGHCp.debug.als | grep -v '^@PG' > /tmp/Sim.pm.q2WhGHCp.debug.als.sorted
diff -uw /tmp/Sim.pm.q2WhGHCp.debug.als.sorted /tmp/Sim.pm.q2WhGHCp.px.als.sorted
PASSED
```

由于测试输出结果过长，这里只显示了部分，感兴趣的同学可以自己安装进行测试。

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                                       | x86信息                     |
| -------- | --------------------------------------------- | --------------------------- |
| 操作系统 | openEuler 20.09                               | openEuler 20.09             |
| 内核版本 | 4.19.90-2110.8.0.0119.oe1.aarch64             | 4.19.90-2003.4.0.0036.oe1.x86_64 |

### 3.2.测试软件环境信息对比

|       | arm信息       | x86信息   |
| ----- | ------------- | --------- |
| gcc   | kgcc 9.3.1    | gcc 9.3.0 |
| bowtie2  | 2.4.5      | 2.4.5     |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息    |
| ------ | ----------- | ---------- |
| cpu    | Kunpeng 920 | Intel(R) Xeon(R) Gold 6278C|
| 核心数 | 8           | 8         |
| 内存   | 16 GB       | 16 GB      |
| 磁盘io | 1.3 GB/s    | 1.3 MB/s   |
| 虚拟化 | KVM         | KVM        |

### 3.4.单线程
单线程运行测试时间对比（五次运行取平均值）
|                | arm    | x86    |
| -------------- | -------- | -------- |
| 实际CPU时间    | 3m2.592s  | 1m46.784s |
| 用户时间       | 2m26.153s | 0m57.053s |

### 3.5.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86       |
| ----------- | ---------- | --------- |
| 线程数      | 4          | 4         |
| 实际CPU时间 | 0m47.075s | 0m35.997s |
| 用户时间    | 0m7.956s  | 0m16.749s   |

arm多线程时间耗费数据表：

| 线程          | 1        | 2       | 4       | 8       |
| :------------ | -------- | ------- | -------- | ------- |
| 用户时间(s)   | 182.592  | 172.340  | 116.716  | 180.501 |
| 用户态时间(s) | 146.153  | 218.942  | 272.470  | 837.371 |
| 内核态时间(s) | 13.765   | 26.512   | 53.088   | 96.164  |

x86多线程时间耗费数据表：
| 线程          | 1        | 2       | 4       | 8       |
| :------------ | -------- | ------- | -------- | ------- |
| 用户时间(s)   | 106.784 | 104.843 | 72.823  | 85.073  |
| 用户态时间(s) | 57.053  | 110.375 | 220.173 | 380.683 |
| 内核态时间(s) | 19.753   | 41.605   | 63.530   | 98.340 |

测试效果取决网络的好坏，因此上述数据可以不做参考，但是从数据不难看出线程为4效果较好

## 4.精度测试

### 4.1.所选测试案例

scripts/sim下的run.pl文件

```perl
use strict;
use warnings;
use Getopt::Long;
use FindBin qw($Bin); 
use lib "$Bin";
use lib "$Bin/contrib";
use Sim;
use ForkManager;

# Simulator configuration
our %conf = (
	bowtie2_build       => "bowtie2-build",
	bowtie2             => "bowtie2",
	bowtie2_build_debug => "bowtie2-build --debug",
	bowtie2_debug       => "bowtie2 --debug",
	tempdir             => "/tmp",
	no_color            => 1,
	small               => 1
);

# Number of parallel processes to use
my $cpus = 1;

my $usage = qq!
run.pl [options*]

Options:

  --bowtie2 <path>              Path to bowtie2 release binary
  --bowtie2-debug <path>        Path to bowtie2 debug binary
  --bowtie2-build <path>        Path to bowtie2-build release binary
  --bowtie2-build-debug <path>  Path to bowtie2-build debug binary
  --tempdir <path>              Put temporary files here
  --cases <int>                 Each thread runs around <int> cases (def: 5)
  --cpus <int> / -p <int>       Run test cases in <int> threads at once
  --maxreads <int>              Handle at most <int> reads per case
  --numrefs <int>               Generate <int> refs per case
  --die-with-child              Kill parent as soon as 1 child dies
  --no-die-with-child           Don\'t kill parent as soon as 1 child dies
  --small                       Make small test cases
  --help                        Print this usage message

!;

my $help = 0;
my $ncases = 5;
my $dieWithChild = 1;

GetOptions(
	"bowtie2=s"             => \$conf{bowtie2},
	"bowtie2-build=s"       => \$conf{bowtie2_build},
	"tempdir|tmpdir=s"      => \$conf{tempdir},
	"cases-per-thread=i"    => \$ncases,
	"small"                 => \$conf{small},
	"large"                 => sub { $conf{small} = 0 },
	"no-paired"             => \$conf{no_paired},
	"color"                 => sub { $conf{no_color} = 0 },
	"no-color"              => \$conf{no_color},
	"help"                  => \$help,
	"die-with-child"        => \$dieWithChild,
	"no-die-with-child"     => sub { $dieWithChild = 0 },
	"p|cpus=i"              => \$cpus,
	"u|qupto|maxreads=i"    => \$conf{maxreads},
	"numrefs|num-refs=i"    => \$conf{numrefs},
) || die "Bad options;";

if($help) {
	print $usage;
	exit 0;
}

my $sim = Sim->new();
my $pm = new Parallel::ForkManager($cpus); 

# Callback for when a child finishes so we can get its exit code
my @childFailed = ();
my @childFailedPid = ();

$pm->run_on_finish(sub {
	my ($pid, $exit_code, $ident) = @_;
	if($exit_code != 0) {
		push @childFailed, $exit_code;
		push @childFailedPid, $pid;
		!$dieWithChild || die "Dying with child with PID $pid";
	}
});

my $totcases = $ncases * $cpus;
for(1..$totcases) {
	my $childPid = $pm->start;
	if($childPid != 0) {
		next; # spawn the next child
	}
	$sim->nextCase(\%conf);
	$pm->finish;
}
$pm->wait_all_children;
for(@childFailedPid) {
	print STDERR "Error message from child with pid $_:\n";
	my $fn = ".run.pl.child.$_";
	if(open(ER, $fn)) {
		print STDERR "---------\n";
		while(<ER>) {
			print STDERR $_;
		}
		print STDERR "---------\n";
		close(ER);
	} else {
		print STDERR "(could not open $fn)\n";
	}
}
print STDERR "PASSED\n";
```

### 4.2.获取对比数据

arm 运行结果(部分)

```bash
156 reads; of these:
  156 (100.00%) were paired; of these:
    156 (100.00%) aligned concordantly 0 times
    0 (0.00%) aligned concordantly exactly 1 time
    0 (0.00%) aligned concordantly >1 times
    ----
    156 pairs aligned concordantly 0 times; of these:
      0 (0.00%) aligned discordantly 1 time
    ----
    156 pairs aligned 0 times concordantly or discordantly; of these:
      312 mates make up the pairs; of these:
        293 (93.91%) aligned 0 times
        16 (5.17%) aligned exactly 1 time
        3 (0.92%) aligned >1 times
6.09% overall alignment rate
diff -uw /tmp/Sim.pm.Sx0_YrOH.debug.als /tmp/Sim.pm.Sx0_YrOH.px.reord.als
PASSED
```

### 4.3.测试总结
从arm输出结果可以看出测试通过，误差为0.92%，所有运算结果偏差在1%以内，偏差较小。