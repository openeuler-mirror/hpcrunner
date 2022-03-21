install numactl-devel, in order to use numa.h
1.rpm -ivh numactl-devel-2.0.13-4.ky10.x86_64.rpm
compile
2.make
start perf...
3.perf c2c record ./false_sharing.exe 2
start report...
4.perf c2c report -NN -g -c pid,iaddr --stdio
  Load Local HITM                   :       2010 【too High, false_sharing is detected】
  Load Remote HITM                  :       1315
  Load Remote HIT                   :          0
  Load Local DRAM                   :         71
  Load Remote DRAM                  :       1881
  Load MESI State Exclusive         :       1881
  Load MESI State Shared            :         71
  Load LLC Misses                   :       3267
  LLC Misses to Local DRAM          :        2.2%
  LLC Misses to Remote DRAM         :       57.6%
  LLC Misses to Remote cache (HIT)  :        0.0%
  LLC Misses to Remote cache (HITM) :       40.3%
compile no false_sharing code
7.gcc -g false_sharing_example.c -pthread -lnuma -DNO_FALSE_SHARING -o no_false_sharing.exe
8.perf c2c report -NN -g -c pid,iaddr --stdio
  Load Local HITM                   :          6【normal, false_sharing is erased】
  Load Remote HITM                  :        486
  Load Remote HIT                   :          0
  Load Local DRAM                   :          1
  Load Remote DRAM                  :        498
  Load MESI State Exclusive         :        498
  Load MESI State Shared            :          1
  Load LLC Misses                   :        985
  LLC Misses to Local DRAM          :        0.1%
  LLC Misses to Remote DRAM         :       50.6%
  LLC Misses to Remote cache (HIT)  :        0.0%
  LLC Misses to Remote cache (HITM) :       49.3%