# 《基于openEuler的scotch软件测试报告》

## 1.规范性自检

项目使用了cppcheck、sonarqube、rats对文件进行格式化

Cppcheck 是一种 C/C++ 代码缺陷静态检查工具。不同于 C/C++ 编译器及很多其它分析工具，它不检查代码中的语法错误。Cppcheck 只检查编译器检查不出来的 bug 类型，其目的是检查代码中真正的错误（即：零误报）。

RATS是一个针对C、c++、PHP、Perl和Python代码的安全审计实用程序。RATS扫描源代码，发现潜在危险的函数调用。

SonarQube 是一种自我管理的自动代码审查工具，可系统地帮助交付干净的代码。 SonarQube集成到现有的工作流程中并检测代码中的问题，该工具分析30多种不同的编程语言，并集成到您的 CI 管道和 DevOps 平台中，以确保代码符合高质量标准。

文件格式化配置参考文件`./ci/analysis.sh`，文件内容如下

```bash
#!/bin/sh

export LCOVFILES=""
for filename in $(ls -1 scotch-*.lcov); do export LCOVFILES="$LCOVFILES -a $filename"; done
lcov $LCOVFILES -o scotch.lcov
lcov_cobertura.py scotch.lcov --output scotch-coverage.xml

export CPPCHECK_DEFINITIONS="$(grep SCOTCH_GITLAB_SEPARATOR < src/Makefile.inc | sed -e 's#^CFLAGS.*SCOTCH_GITLAB_SEPARATOR##1' | sed -e 's#[ ][^-][^ ]*##g' -e 's#[ ][-][^D][^ ]*##g')"
export CPPCHECK_INCLUDES="-Isrc/scotch -Isrc/misc -Isrc/libscotch -Isrc/esmumps -Isrc/libscotchmetis"

./ci/gitlab-ci-filelist.sh

cppcheck -v --max-configs=1 --language=c ${CPPCHECK_DEFINITIONS_VM:---platform=native} --enable=all --xml --xml-version=2 --suppress=missingIncludeSystem --suppress=varFuncNullUB --suppress=invalidPrintfArgType_sint ${CPPCHECK_DEFINITIONS} ${CPPCHECK_INCLUDES} --file-list=./filelist.txt 2> scotch-cppcheck.xml

rats -w 3 --xml `cat filelist.txt` > scotch-rats.xml

# sonar.projectKey=tadaam:scotch:gitlab:$CI_PROJECT_NAMESPACE:$CI_COMMIT_REF_NAME
# sonar.projectKey=tadaam:scotch:gitlab:$CI_PROJECT_NAMESPACE
# sonar.branch.name=$CI_COMMIT_REF_NAME
# sonar.exclusions=build/**,cmake_modules/**,doc/**,tools/**,**/*.xml
# "sonar.lang.patterns.c++=**/*.cpp,**/*.hpp" : needed so that C files are not considered as C++ files
cat > sonar-project.properties << EOF
sonar.host.url=https://sonarqube.inria.fr/sonarqube
sonar.login=$SONARQUBE_LOGIN
sonar.links.homepage=$CI_PROJECT_URL
sonar.links.scm=$CI_REPOSITORY_URL
sonar.links.ci=https://gitlab.inria.fr/$CI_PROJECT_NAMESPACE/scotch/pipelines
sonar.links.issue=https://gitlab.inria.fr/$CI_PROJECT_NAMESPACE/scotch/issues
sonar.projectKey=tadaam:scotch:gitlab:$CI_PROJECT_NAMESPACE
sonar.branch.name=$CI_COMMIT_REF_NAME
sonar.projectDescription=Package for graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering.
sonar.projectVersion=6.1
sonar.sourceEncoding=UTF-8
sonar.sources=include,src/check,src/esmumps,src/libscotch,src/libscotchmetis,src/misc,src/scotch
sonar.lang.patterns.c++=**/*.cpp,**/*.hpp
sonar.lang.patterns.c=**/*.c,**/*.h
sonar.exclusions=src/libscotch/dummysizes.c,src/libscotch/parser_ll.c,src/libscotch/parser_yy.c,src/libscotch/last_resort/**
sonar.c.includeDirectories=$(echo | gcc -E -Wp,-v - 2>&1 | grep "^ " | tr '\n' ',')include,src/scotch,src/misc,src/libscotch,src/esmumps,src/libscotchmetis,/usr/include/openmpi,/usr/include/mpich
sonar.c.errorRecoveryEnabled=true
sonar.c.gcc.charset=UTF-8
sonar.c.gcc.regex=(?<file>.*):(?<line>[0-9]+):[0-9]+:\\\x20warning:\\\x20(?<message>.*)\\\x20\\\[(?<id>.*)\\\]
sonar.c.gcc.reportPath=scotch-build*.log
sonar.c.coverage.reportPath=scotch-coverage.xml
sonar.c.cppcheck.reportPath=scotch-cppcheck.xml
sonar.c.rats.reportPath=scotch-rats.xml
sonar.c.clangsa.reportPath=analyzer_reports/*/*.plist
EOF
```

对于当前项目，检查代码规范性，可以通过使用Clang-Format对所有源码进行重新格式化，然后使用git查看文件修改。

统计代码不规范内容。

### 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```python
import os

print(os.getcwd())

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

all_files = getAllFiles(os.curdir)
type_dict = dict()

for each_file in all_files:
    if os.path.isdir(each_file):
        type_dict.setdefault("directory", 0)
        type_dict["directory"] += 1
    else:
        ext = os.path.splitext(each_file)[1]
        type_dict.setdefault(ext, 0)
        type_dict[ext] += 1

for each_type in dict(sorted(type_dict.items(), reverse=True, key=lambda item: item[1])).keys():
    print("当前文件夹下共有[%s]的文件%d个" % (each_type, type_dict[each_type]))
```

在scotch项目根目录下运行,运行结果如下

```bash
⋊> /root/scotch python3 ../count.py
/root/scotch
当前文件夹下共有[.c]的文件454个
当前文件夹下共有[.h]的文件233个
当前文件夹下共有[.tgt]的文件69个
当前文件夹下共有[.txt]的文件41个
当前文件夹下共有[.eps]的文件29个
当前文件夹下共有[]的文件25个
当前文件夹下共有[.tex]的文件25个
当前文件夹下共有[.fig]的文件25个
当前文件夹下共有[.1]的文件24个
当前文件夹下共有[.grf]的文件23个
当前文件夹下共有[.sample]的文件13个
当前文件夹下共有[.gz]的文件11个
当前文件夹下共有[.ps]的文件10个
当前文件夹下共有[.gif]的文件10个
当前文件夹下共有[.pdf]的文件7个
当前文件夹下共有[.sh]的文件5个
当前文件夹下共有[.sty]的文件4个
当前文件夹下共有[.png]的文件4个
当前文件夹下共有[.shlib]的文件4个
当前文件夹下共有[.debug]的文件4个
当前文件夹下共有[.F]的文件3个
当前文件夹下共有[.src]的文件3个
当前文件夹下共有[.msh]的文件3个
当前文件夹下共有[.f]的文件2个
当前文件夹下共有[.cmake]的文件2个
当前文件夹下共有[.bib]的文件2个
当前文件夹下共有[.xyz]的文件2个
当前文件夹下共有[.map]的文件2个
当前文件夹下共有[.icc]的文件2个
当前文件夹下共有[.md]的文件1个
当前文件夹下共有[.pack]的文件1个
当前文件夹下共有[.idx]的文件1个
当前文件夹下共有[.in]的文件1个
当前文件夹下共有[.xml]的文件1个
当前文件夹下共有[.yml]的文件1个
当前文件夹下共有[.inc]的文件1个
当前文件夹下共有[.y]的文件1个
当前文件夹下共有[.l]的文件1个
当前文件夹下共有[.i686_pc_linux3]的文件1个
当前文件夹下共有[.pa11_hp_ux10]的文件1个
当前文件夹下共有[.power3_ibm_aix5]的文件1个
当前文件夹下共有[.x86-64_pc_freebsd]的文件1个
当前文件夹下共有[.bat]的文件1个
当前文件夹下共有[.power6_ibm_aix5]的文件1个
当前文件夹下共有[.i686_pc_mingw32]的文件1个
当前文件夹下共有[.i686_pc_linux2]的文件1个
当前文件夹下共有[.i686_sun_solaris5]的文件1个
当前文件夹下共有[.mips_sgi_irix6]的文件1个
当前文件夹下共有[.prof]的文件1个
当前文件夹下共有[.ppca2_ibm_bgq]的文件1个
当前文件夹下共有[.x86-64_pc_linux2]的文件1个
当前文件夹下共有[.alpha_dec_osf1]的文件1个
当前文件夹下共有[.x86-64_cray-xt4_linux2]的文件1个
当前文件夹下共有[.c99]的文件1个
当前文件夹下共有[.i686_pc_freebsd]的文件1个
当前文件夹下共有[.impi]的文件1个
当前文件夹下共有[.i686_mac_darwin8]的文件1个
当前文件夹下共有[.i686_mac_darwin10]的文件1个
当前文件夹下共有[.ppc450_ibm_bgp]的文件1个
当前文件夹下共有[.nothreads]的文件1个
当前文件夹下共有[.spec]的文件1个
当前文件夹下共有[.f90]的文件1个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`c`,`h`。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.c\|.*\.h\|.*\.cpp" | xargs wc -l
```

统计结果

```bash
   151907 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`c`,`h`, 的所有文件进行格式
通过运行分析脚本的方式进行分析

### 1.4.统计结果

```xml
<?xml version="1.0"?><rats_output>
<stats>
<dbcount lang="perl">33</dbcount>
<dbcount lang="ruby">46</dbcount>
<dbcount lang="python">62</dbcount>
<dbcount lang="c">334</dbcount>
<dbcount lang="php">55</dbcount>
</stats>
<analyzed>src/libscotch/vmesh_separate_ml.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_sq.c</analyzed>
<analyzed>src/libscotch/library_graph_io_chac.c</analyzed>
<analyzed>src/libscotch/library_graph_io_chac_f.c</analyzed>
<analyzed>src/libscotch/wgraph_part_es.c</analyzed>
<analyzed>src/libscotch/dorder_tree_dist.c</analyzed>
<analyzed>src/libscotch/hmesh_order_gp.c</analyzed>
<analyzed>src/libscotch/hmesh_order_nd.c</analyzed>
<analyzed>src/libscotch/mesh_induce_sepa.c</analyzed>
<analyzed>src/libscotch/dgraph_io_save.c</analyzed>
<analyzed>src/libscotch/library_mesh_order_f.c</analyzed>
<analyzed>src/libscotch/graph_io_mmkt.c</analyzed>
<analyzed>src/libscotch/library_graph_diam.c</analyzed>
<analyzed>src/libscotch/bdgraph_check.c</analyzed>
<analyzed>src/libscotch/library_graph_dump.c</analyzed>
<analyzed>src/libscotch/hgraph_order_st.c</analyzed>
<analyzed>src/libscotch/arch_hcub.c</analyzed>
<analyzed>src/libscotch/vmesh_check.c</analyzed>
<analyzed>src/libscotch/library_dgraph_build_f.c</analyzed>
<analyzed>src/libscotch/library_dgraph_coarsen_f.c</analyzed>
<analyzed>src/libscotch/common_values.c</analyzed>
<analyzed>src/libscotch/hmesh_order_hf.c</analyzed>
<analyzed>src/libscotch/arch.c</analyzed>
<analyzed>src/libscotch/library_graph.c</analyzed>
<analyzed>src/libscotch/library_graph_order.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_df.c</analyzed>
<analyzed>src/libscotch/library_parser.c</analyzed>
<analyzed>src/libscotch/arch_deco2.c</analyzed>
<analyzed>src/libscotch/library_context_dgraph_f.c</analyzed>
<analyzed>src/libscotch/library_dgraph_coarsen.c</analyzed>
<analyzed>src/libscotch/graph_dump.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_ex.c</analyzed>
<analyzed>src/libscotch/dgraph_match.c</analyzed>
<analyzed>src/libscotch/library_arch_dom.c</analyzed>
<analyzed>src/libscotch/graph.c</analyzed>
<analyzed>src/libscotch/kdgraph_gather.c</analyzed>
<analyzed>src/libscotch/wgraph_part_ml.c</analyzed>
<analyzed>src/libscotch/library_dgraph_check_f.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_ml.c</analyzed>
<analyzed>src/libscotch/dgraph_ghst.c</analyzed>
<analyzed>src/libscotch/dgraph_check.c</analyzed>
<analyzed>src/libscotch/dgraph_fold_comm.c</analyzed>
<analyzed>src/libscotch/library_dgraph_map_f.c</analyzed>
<analyzed>src/libscotch/dorder_io.c</analyzed>
<analyzed>src/libscotch/common_stub.c</analyzed>
<analyzed>src/libscotch/dgraph_induce.c</analyzed>
<analyzed>src/libscotch/hgraph_induce.c</analyzed>
<analyzed>src/libscotch/library_dgraph_build_grid3d.c</analyzed>
<analyzed>src/libscotch/hgraph_order_cc.c</analyzed>
<analyzed>src/libscotch/library_strat.c</analyzed>
<analyzed>src/libscotch/graph_ielo.c</analyzed>
<analyzed>src/libscotch/library_dgraph_scatter_f.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_ml.c</analyzed>
<analyzed>src/libscotch/mesh_coarsen.c</analyzed>
<analyzed>src/libscotch/library_mesh_io_habo_f.c</analyzed>
<analyzed>src/libscotch/mesh_io.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_gather_f.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_st.c</analyzed>
<analyzed>src/libscotch/library_mesh_f.c</analyzed>
<analyzed>src/libscotch/library_geom_f.c</analyzed>
<analyzed>src/libscotch/dorder_io_block.c</analyzed>
<analyzed>src/libscotch/hmesh_order_bl.c</analyzed>
<analyzed>src/libscotch/library_error_exit.c</analyzed>
<analyzed>src/libscotch/common_sort.c</analyzed>
<analyzed>src/libscotch/arch_sub.c</analyzed>
<analyzed>src/libscotch/wgraph_store.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_tree_dist_f.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_gg.c</analyzed>
<analyzed>src/libscotch/library_context_mesh_f.c</analyzed>
<analyzed>src/libscotch/graph_induce.c</analyzed>
<analyzed>src/libscotch/common_file_compress.c</analyzed>
<analyzed>src/libscotch/hgraph_order_hd.c</analyzed>
<analyzed>src/libscotch/library_dgraph_f.c</analyzed>
<analyzed>src/libscotch/library_dmapping.c</analyzed>
<analyzed>src/libscotch/mapping.c</analyzed>
<analyzed>src/libscotch/bdgraph_store.c</analyzed>
<analyzed>src/libscotch/hall_order_hd.c</analyzed>
<analyzed>src/libscotch/library_common_f.c</analyzed>
<analyzed>src/libscotch/wgraph_check.c</analyzed>
<analyzed>src/libscotch/hgraph_order_gp.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_st.c</analyzed>
<analyzed>src/libscotch/bgraph_store.c</analyzed>
<analyzed>src/libscotch/library_dgraph_map_view_f.c</analyzed>
<analyzed>src/libscotch/vdgraph_check.c</analyzed>
<analyzed>src/libscotch/hdgraph.c</analyzed>
<analyzed>src/libscotch/hmesh_order_si.c</analyzed>
<analyzed>src/libscotch/library_graph_coarsen_f.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_bd.c</analyzed>
<analyzed>src/libscotch/library_order.c</analyzed>
<analyzed>src/libscotch/library_context_f.c</analyzed>
<analyzed>src/libscotch/arch_torus.c</analyzed>
<analyzed>src/libscotch/dgraph_gather.c</analyzed>
<analyzed>src/libscotch/mesh_io_scot.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_gp.c</analyzed>
<analyzed>src/libscotch/library_mesh_order.c</analyzed>
<analyzed>src/libscotch/library_graph_diam_f.c</analyzed>
<analyzed>src/libscotch/hmesh_hgraph.c</analyzed>
<analyzed>src/libscotch/geom.c</analyzed>
<analyzed>src/libscotch/graph_coarsen_edge.c</analyzed>
<analyzed>src/libscotch/library_error.c</analyzed>
<analyzed>src/libscotch/library_dgraph_build_grid3d_f.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_ml.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_es.c</analyzed>
<analyzed>src/libscotch/library_mesh_io_scot_f.c</analyzed>
<analyzed>src/libscotch/library_mesh_graph.c</analyzed>
<analyzed>src/libscotch/library_geom.c</analyzed>
<analyzed>src/libscotch/library_graph_io_habo_f.c</analyzed>
<analyzed>src/libscotch/bdgraph.c</analyzed>
<analyzed>src/libscotch/library_arch_f.c</analyzed>
<analyzed>src/libscotch/vgraph_store.c</analyzed>
<analyzed>src/libscotch/wgraph_part_rb.c</analyzed>
<analyzed>src/libscotch/hdgraph_fold.c</analyzed>
<analyzed>src/libscotch/library_graph_io_mmkt.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_df.c</analyzed>
<analyzed>src/libscotch/vdgraph.c</analyzed>
<analyzed>src/libscotch/kgraph_map_rb.c</analyzed>
<analyzed>src/libscotch/vmesh_separate_st.c</analyzed>
<analyzed>src/libscotch/dmapping_io.c</analyzed>
<analyzed>src/libscotch/arch_dist.c</analyzed>
<analyzed>src/libscotch/mapping_io.c</analyzed>
<analyzed>src/libscotch/library_graph_io_habo.c</analyzed>
<analyzed>src/libscotch/library_mesh_io_scot.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_f.c</analyzed>
<analyzed>src/libscotch/dorder_perm.c</analyzed>
<analyzed>src/libscotch/mesh_graph.c</analyzed>
<analyzed>src/libscotch/order_io.c</analyzed>
<analyzed>src/libscotch/kgraph_map_ex.c</analyzed>
<analyzed>src/libscotch/library_context_graph.c</analyzed>
<analyzed>src/libscotch/vmesh_store.c</analyzed>
<analyzed>src/libscotch/wgraph_part_fm.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_zr.c</analyzed>
<analyzed>src/libscotch/library_context_dgraph.c</analyzed>
<analyzed>src/libscotch/hmesh_induce.c</analyzed>
<analyzed>src/libscotch/library_graph_f.c</analyzed>
<analyzed>src/libscotch/library_memory_f.c</analyzed>
<analyzed>src/libscotch/hgraph_order_hf.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_gp.c</analyzed>
<analyzed>src/libscotch/kgraph_store.c</analyzed>
<analyzed>src/libscotch/dgraph.c</analyzed>
<analyzed>src/libscotch/library_graph_part_ovl_f.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_gg.c</analyzed>
<analyzed>src/libscotch/library_graph_color.c</analyzed>
<analyzed>src/libscotch/library_dgraph_redist.c</analyzed>
<analyzed>src/libscotch/library_dgraph_stat_f.c</analyzed>
<analyzed>src/libscotch/kgraph_map_df.c</analyzed>
<analyzed>src/libscotch/order.c</analyzed>
<analyzed>src/libscotch/library_dgraph_band_f.c</analyzed>
<analyzed>src/libscotch/kgraph_map_rb_map.c</analyzed>
<analyzed>src/libscotch/library_dgraph_io_save.c</analyzed>
<analyzed>src/libscotch/library_version_f.c</analyzed>
<analyzed>src/libscotch/dgraph_fold.c</analyzed>
<analyzed>src/libscotch/library_graph_coarsen.c</analyzed>
<analyzed>src/libscotch/fibo.c</analyzed>
<analyzed>src/libscotch/common.c</analyzed>
<analyzed>src/libscotch/graph_check.c</analyzed>
<analyzed>src/libscotch/library_graph_induce.c</analyzed>
<analyzed>src/libscotch/library_mesh_graph_f.c</analyzed>
<analyzed>src/libscotch/kdgraph_map_rb.c</analyzed>
<analyzed>src/libscotch/dorder.c</analyzed>
<analyzed>src/libscotch/common_thread_system.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_zr.c</analyzed>
<analyzed>src/libscotch/dmapping.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_ex.c</analyzed>
<analyzed>src/libscotch/hmesh_order_cp.c</analyzed>
<analyzed>src/libscotch/vmesh_separate_gg.c</analyzed>
<analyzed>src/libscotch/hgraph_check.c</analyzed>
<analyzed>src/libscotch/library_dgraph_induce.c</analyzed>
<analyzed>src/libscotch/library_dgraph_io_save_f.c</analyzed>
<analyzed>src/libscotch/dummysizes.c</analyzed>
<analyzed>src/libscotch/arch_vcmplt.c</analyzed>
<analyzed>src/libscotch/dgraph_fold_dup.c</analyzed>
<analyzed>src/libscotch/library_graph_order_f.c</analyzed>
<analyzed>src/libscotch/hmesh_order_hd.c</analyzed>
<analyzed>src/libscotch/library_context.c</analyzed>
<analyzed>src/libscotch/library_dgraph_gather_f.c</analyzed>
<analyzed>src/libscotch/hall_order_hx.c</analyzed>
<analyzed>src/libscotch/library_dgraph.c</analyzed>
<analyzed>src/libscotch/graph_io_chac.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_io_f.c</analyzed>
<analyzed>src/libscotch/dgraph_io_load.c</analyzed>
<analyzed>src/libscotch/dgraph_band_grow.c</analyzed>
<analyzed>src/libscotch/dgraph_halo_fill.c</analyzed>
<analyzed>src/libscotch/hmesh_check.c</analyzed>
<analyzed>src/libscotch/dgraph_match_sync_coll.c</analyzed>
<analyzed>src/libscotch/hmesh_order_gr.c</analyzed>
<analyzed>src/libscotch/kdgraph_map_rb_map.c</analyzed>
<analyzed>src/libscotch/kgraph_map_rb_part.c</analyzed>
<analyzed>src/libscotch/library_parser_f.c</analyzed>
<analyzed>src/libscotch/dgraph_compact.c</analyzed>
<analyzed>src/libscotch/library_dgraph_scatter.c</analyzed>
<analyzed>src/libscotch/hgraph_dump.c</analyzed>
<analyzed>src/libscotch/kgraph_map_fm.c</analyzed>
<analyzed>src/libscotch/library_dgraph_halo.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_fm.c</analyzed>
<analyzed>src/libscotch/library_dgraph_redist_f.c</analyzed>
<analyzed>src/libscotch/dgraph_coarsen.c</analyzed>
<analyzed>src/libscotch/library_arch.c</analyzed>
<analyzed>src/libscotch/dorder_io_tree.c</analyzed>
<analyzed>src/libscotch/mesh_io_habo.c</analyzed>
<analyzed>src/libscotch/dgraph_match_check.c</analyzed>
<analyzed>src/libscotch/hdgraph_order_sq.c</analyzed>
<analyzed>src/libscotch/vgraph_check.c</analyzed>
<analyzed>src/libscotch/dgraph_redist.c</analyzed>
<analyzed>src/libscotch/wgraph.c</analyzed>
<analyzed>src/libscotch/common_error.c</analyzed>
<analyzed>src/libscotch/graph_match.c</analyzed>
<analyzed>src/libscotch/library_graph_map.c</analyzed>
<analyzed>src/libscotch/dgraph_match_scan.c</analyzed>
<analyzed>src/libscotch/bgraph_check.c</analyzed>
<analyzed>src/libscotch/common_context.c</analyzed>
<analyzed>src/libscotch/library_random_f.c</analyzed>
<analyzed>src/libscotch/kgraph_map_bd.c</analyzed>
<analyzed>src/libscotch/kgraph_check.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_fm.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_st.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_tree_dist.c</analyzed>
<analyzed>src/libscotch/common_psort.c</analyzed>
<analyzed>src/libscotch/common_memory.c</analyzed>
<analyzed>src/libscotch/hgraph_order_nd.c</analyzed>
<analyzed>src/libscotch/graph_io_scot.c</analyzed>
<analyzed>src/libscotch/library_dorder.c</analyzed>
<analyzed>src/libscotch/common_thread.c</analyzed>
<analyzed>src/libscotch/library_mapping.c</analyzed>
<analyzed>src/libscotch/mesh.c</analyzed>
<analyzed>src/libscotch/library_graph_base.c</analyzed>
<analyzed>src/libscotch/graph_band.c</analyzed>
<analyzed>src/libscotch/parser.c</analyzed>
<analyzed>src/libscotch/hall_order_hf.c</analyzed>
<analyzed>src/libscotch/graph_list.c</analyzed>
<analyzed>src/libscotch/dorder_gather.c</analyzed>
<analyzed>src/libscotch/vdgraph_store.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_df.c</analyzed>
<analyzed>src/libscotch/library_errcom.c</analyzed>
<analyzed>src/libscotch/library_graph_map_io.c</analyzed>
<analyzed>src/libscotch/vdgraph_gather_all.c</analyzed>
<analyzed>src/libscotch/kdgraph_map_st.c</analyzed>
<analyzed>src/libscotch/wgraph_part_st.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_bd.c</analyzed>
<analyzed>src/libscotch/kgraph_band.c</analyzed>
<analyzed>src/libscotch/arch_build.c</analyzed>
<analyzed>src/libscotch/graph_io_habo.c</analyzed>
<analyzed>src/libscotch/library_arch_build.c</analyzed>
<analyzed>src/libscotch/hgraph_order_kp.c</analyzed>
<analyzed>src/libscotch/kgraph_map_st.c</analyzed>
<analyzed>src/libscotch/library_graph_io_scot_f.c</analyzed>
<analyzed>src/libscotch/common_string.c</analyzed>
<analyzed>src/libscotch/library_mesh.c</analyzed>
<analyzed>src/libscotch/hgraph_order_cp.c</analyzed>
<analyzed>src/libscotch/dgraph_view.c</analyzed>
<analyzed>src/libscotch/library_dgraph_halo_f.c</analyzed>
<analyzed>src/libscotch/arch_build2.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_sq.c</analyzed>
<analyzed>src/libscotch/library_arch_dom_f.c</analyzed>
<analyzed>src/libscotch/order_check.c</analyzed>
<analyzed>src/libscotch/library_dgraph_grow.c</analyzed>
<analyzed>src/libscotch/library_graph_map_view_f.c</analyzed>
<analyzed>src/libscotch/vmesh_separate_fm.c</analyzed>
<analyzed>src/libscotch/dgraph_allreduce.c</analyzed>
<analyzed>src/libscotch/vmesh_separate_zr.c</analyzed>
<analyzed>src/libscotch/common_file.c</analyzed>
<analyzed>src/libscotch/hgraph_induce_edge.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_perm_f.c</analyzed>
<analyzed>src/libscotch/hdgraph_check.c</analyzed>
<analyzed>src/libscotch/library_graph_io_scot.c</analyzed>
<analyzed>src/libscotch/library_graph_base_f.c</analyzed>
<analyzed>src/libscotch/hmesh_mesh.c</analyzed>
<analyzed>src/libscotch/library_graph_check_f.c</analyzed>
<analyzed>src/libscotch/wgraph_part_zr.c</analyzed>
<analyzed>src/libscotch/dgraph_band.c</analyzed>
<analyzed>src/libscotch/graph_base.c</analyzed>
<analyzed>src/libscotch/library_graph_map_io_f.c</analyzed>
<analyzed>src/libscotch/library_dgraph_stat.c</analyzed>
<analyzed>src/libscotch/arch_tleaf.c</analyzed>
<analyzed>src/libscotch/hmesh_order_st.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_bd.c</analyzed>
<analyzed>src/libscotch/gain.c</analyzed>
<analyzed>src/libscotch/dgraph_build_hcub.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order.c</analyzed>
<analyzed>src/libscotch/library_graph_check.c</analyzed>
<analyzed>src/libscotch/vmesh_separate_gr.c</analyzed>
<analyzed>src/libscotch/library_dgraph_check.c</analyzed>
<analyzed>src/libscotch/vmesh.c</analyzed>
<analyzed>src/libscotch/hmesh.c</analyzed>
<analyzed>src/libscotch/library_memory.c</analyzed>
<analyzed>src/libscotch/library_dgraph_induce_f.c</analyzed>
<analyzed>src/libscotch/dgraph_match_sync_ptop.c</analyzed>
<analyzed>src/libscotch/dgraph_build.c</analyzed>
<analyzed>src/libscotch/library_dgraph_gather.c</analyzed>
<analyzed>src/libscotch/hdgraph_order_si.c</analyzed>
<analyzed>src/libscotch/library_graph_part_ovl.c</analyzed>
<analyzed>src/libscotch/vgraph.c</analyzed>
<analyzed>src/libscotch/kdgraph.c</analyzed>
<analyzed>src/libscotch/hgraph_order_hx.c</analyzed>
<analyzed>src/libscotch/comm.c</analyzed>
<analyzed>src/libscotch/kdgraph_map_rb_part.c</analyzed>
<analyzed>src/libscotch/hdgraph_order_st.c</analyzed>
<analyzed>src/libscotch/library_context_mesh.c</analyzed>
<analyzed>src/libscotch/library_dgraph_map.c</analyzed>
<analyzed>src/libscotch/library_graph_induce_f.c</analyzed>
<analyzed>src/libscotch/library_version.c</analyzed>
<analyzed>src/libscotch/arch_deco.c</analyzed>
<analyzed>src/libscotch/graph_diam.c</analyzed>
<analyzed>src/libscotch/library_graph_map_f.c</analyzed>
<analyzed>src/libscotch/bgraph.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_th.c</analyzed>
<analyzed>src/libscotch/arch_mesh.c</analyzed>
<analyzed>src/libscotch/library_graph_io_mmkt_f.c</analyzed>
<analyzed>src/libscotch/kgraph_map_cp.c</analyzed>
<analyzed>src/libscotch/library_random.c</analyzed>
<analyzed>src/libscotch/library_context_graph_f.c</analyzed>
<analyzed>src/libscotch/graph_coarsen.c</analyzed>
<analyzed>src/libscotch/library_dgraph_io_load_f.c</analyzed>
<analyzed>src/libscotch/hgraph_order_bl.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_bd.c</analyzed>
<analyzed>src/libscotch/dgraph_halo.c</analyzed>
<analyzed>src/libscotch/hgraph.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_st.c</analyzed>
<analyzed>src/libscotch/hgraph_order_si.c</analyzed>
<analyzed>src/libscotch/vgraph_separate_vw.c</analyzed>
<analyzed>src/libscotch/library_graph_map_view.c</analyzed>
<analyzed>src/libscotch/kgraph_map_ml.c</analyzed>
<analyzed>src/libscotch/arch_cmpltw.c</analyzed>
<analyzed>src/libscotch/library_dgraph_band.c</analyzed>
<analyzed>src/libscotch/library_dgraph_io_load.c</analyzed>
<analyzed>src/libscotch/hdgraph_induce.c</analyzed>
<analyzed>src/libscotch/mesh_check.c</analyzed>
<analyzed>src/libscotch/hdgraph_gather.c</analyzed>
<analyzed>src/libscotch/graph_clone.c</analyzed>
<analyzed>src/libscotch/library_dgraph_map_view.c</analyzed>
<analyzed>src/libscotch/bgraph_bipart_zr.c</analyzed>
<analyzed>src/libscotch/dgraph_build_grid3d.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_zr.c</analyzed>
<analyzed>src/libscotch/hmesh_order_hx.c</analyzed>
<analyzed>src/libscotch/bdgraph_gather_all.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_io.c</analyzed>
<analyzed>src/libscotch/arch_cmplt.c</analyzed>
<analyzed>src/libscotch/common_integer.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_perm.c</analyzed>
<analyzed>src/libscotch/bdgraph_bipart_df.c</analyzed>
<analyzed>src/libscotch/library_graph_color_f.c</analyzed>
<analyzed>src/libscotch/library_mesh_io_habo.c</analyzed>
<analyzed>src/libscotch/library_arch_build_f.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_io_block.c</analyzed>
<analyzed>src/libscotch/dgraph_scatter.c</analyzed>
<analyzed>src/libscotch/graph_io.c</analyzed>
<analyzed>src/libscotch/vdgraph_separate_ml.c</analyzed>
<analyzed>src/libscotch/graph_match_scan.c</analyzed>
<analyzed>src/libscotch/common_file_decompress.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_io_block_f.c</analyzed>
<analyzed>src/libscotch/dgraph_gather_all.c</analyzed>
<analyzed>src/libscotch/kgraph.c</analyzed>
<analyzed>src/libscotch/hdgraph_order_nd.c</analyzed>
<analyzed>src/libscotch/context.c</analyzed>
<analyzed>src/libscotch/library_dgraph_build.c</analyzed>
<analyzed>src/libscotch/arch_vhcub.c</analyzed>
<analyzed>src/libscotch/library_dgraph_order_gather.c</analyzed>
<analyzed>src/libscotchmetis/parmetis_dgraph_order.c</analyzed>
<analyzed>src/libscotchmetis/metis_options.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_order.c</analyzed>
<analyzed>src/libscotchmetis/metis_options_f.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_dual.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_part_dual.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_part_f.c</analyzed>
<analyzed>src/libscotchmetis/parmetis_dgraph_order_f.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_part.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_part_dual_f.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_dual_f.c</analyzed>
<analyzed>src/libscotchmetis/parmetis_dgraph_part_f.c</analyzed>
<analyzed>src/libscotchmetis/metis_graph_order_f.c</analyzed>
<analyzed>src/libscotchmetis/parmetis_dgraph_part.c</analyzed>
<analyzed>src/esmumps/symbol_fax_graph.c</analyzed>
<analyzed>src/esmumps/symbol.c</analyzed>
<analyzed>src/esmumps/library_esmumps_strats.c</analyzed>
<analyzed>src/esmumps/order_scotch_graph.c</analyzed>
<analyzed>src/esmumps/main_esmumps.c</analyzed>
<analyzed>src/esmumps/order.c</analyzed>
<analyzed>src/esmumps/symbol_fax.c</analyzed>
<analyzed>src/esmumps/library_esmumps.c</analyzed>
<analyzed>src/esmumps/esmumps.c</analyzed>
<analyzed>src/esmumps/order_check.c</analyzed>
<analyzed>src/esmumps/symbol_cost.c</analyzed>
<analyzed>src/esmumps/library_esmumps_f.c</analyzed>
<analyzed>src/esmumps/dof.c</analyzed>
<analyzed>src/esmumps/symbol_check.c</analyzed>
<analyzed>src/esmumps/graph_graph.c</analyzed>
<analyzed>src/scotch/dgord.c</analyzed>
<analyzed>src/scotch/dgtst.c</analyzed>
<analyzed>src/scotch/gscat.c</analyzed>
<analyzed>src/scotch/gtst.c</analyzed>
<analyzed>src/scotch/amk_grf.c</analyzed>
<analyzed>src/scotch/amk_hy.c</analyzed>
<analyzed>src/scotch/gcv.c</analyzed>
<analyzed>src/scotch/gotst.c</analyzed>
<analyzed>src/scotch/mmk_m3.c</analyzed>
<analyzed>src/scotch/amk_m2.c</analyzed>
<analyzed>src/scotch/gmk_msh.c</analyzed>
<analyzed>src/scotch/gmk_m2.c</analyzed>
<analyzed>src/scotch/gmtst.c</analyzed>
<analyzed>src/scotch/amk_p2.c</analyzed>
<analyzed>src/scotch/dggath.c</analyzed>
<analyzed>src/scotch/amk_ccc.c</analyzed>
<analyzed>src/scotch/gord.c</analyzed>
<analyzed>src/scotch/mcv.c</analyzed>
<analyzed>src/scotch/dgmap.c</analyzed>
<analyzed>src/scotch/gdump.c</analyzed>
<analyzed>src/scotch/gmk_m3.c</analyzed>
<analyzed>src/scotch/gmk_ub2.c</analyzed>
<analyzed>src/scotch/amk_fft2.c</analyzed>
<analyzed>src/scotch/mord.c</analyzed>
<analyzed>src/scotch/gmk_hy.c</analyzed>
<analyzed>src/scotch/gout_o.c</analyzed>
<analyzed>src/scotch/gmap.c</analyzed>
<analyzed>src/scotch/gbase.c</analyzed>
<analyzed>src/scotch/atst.c</analyzed>
<analyzed>src/scotch/mmk_m2.c</analyzed>
<analyzed>src/scotch/acpl.c</analyzed>
<analyzed>src/scotch/gout_c.c</analyzed>
<analyzed>src/scotch/dgscat.c</analyzed>
<analyzed>src/scotch/mtst.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_band.c</analyzed>
<analyzed>src/check/test_scotch_mesh_graph.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_check.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_induce.c</analyzed>
<analyzed>src/check/test_libmetis.c</analyzed>
<analyzed>src/check/test_scotch_graph_induce.c</analyzed>
<analyzed>src/check/test_scotch_graph_diam.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_redist.c</analyzed>
<analyzed>src/check/test_scotch_arch.c</analyzed>
<analyzed>src/check/test_fibo.c</analyzed>
<analyzed>src/check/test_strat_par.c</analyzed>
<analyzed>src/check/test_strat_seq.c</analyzed>
<analyzed>src/check/test_scotch_context.c</analyzed>
<analyzed>src/check/test_scotch_graph_coarsen.c</analyzed>
<analyzed>src/check/test_common_random.c</analyzed>
<analyzed>src/check/test_libmetis_dual.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_grow.c</analyzed>
<analyzed>src/check/test_libesmumps.c</analyzed>
<analyzed>src/check/test_common_thread.c</analyzed>
<analyzed>src/check/test_scotch_graph_map_copy.c</analyzed>
<analyzed>src/check/test_scotch_graph_part_ovl.c</analyzed>
<analyzed>src/check/test_scotch_graph_order.c</analyzed>
<analyzed>src/check/test_common_file_compress.c</analyzed>
<analyzed>src/check/test_scotch_graph_map.c</analyzed>
<analyzed>src/check/test_scotch_graph_color.c</analyzed>
<analyzed>src/check/test_scotch_arch_deco.c</analyzed>
<analyzed>src/check/test_scotch_graph_dump.c</analyzed>
<analyzed>src/check/test_multilib.c</analyzed>
<analyzed>src/check/test_scotch_dgraph_coarsen.c</analyzed>
<vulnerability>
  <severity>High</severity>
  <type>fixed size global buffer</type>
  <message>
    Extra care should be taken to ensure that character arrays that are
    allocated on the stack are used safely.  They are prime targets for
    buffer overflow attacks.
  </message>
  <file>
    <name>src/libscotch/dgraph_io_save.c</name>
    <line>78</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_mmkt.c</name>
    <line>101</line>
  </file>
  <file>
    <name>src/libscotch/arch.c</name>
    <line>193</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_order.c</name>
    <line>506</line>
    <line>507</line>
    <line>508</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io.c</name>
    <line>102</line>
    <line>325</line>
  </file>
  <file>
    <name>src/libscotch/library_mesh_order.c</name>
    <line>409</line>
    <line>410</line>
  </file>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>181</line>
    <line>182</line>
    <line>183</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_chac.c</name>
    <line>84</line>
    <line>89</line>
  </file>
  <file>
    <name>src/libscotch/dgraph_io_load.c</name>
    <line>199</line>
    <line>669</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io_habo.c</name>
    <line>78</line>
    <line>79</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map.c</name>
    <line>654</line>
    <line>655</line>
    <line>656</line>
    <line>657</line>
    <line>658</line>
    <line>723</line>
    <line>724</line>
    <line>725</line>
    <line>726</line>
  </file>
  <file>
    <name>src/libscotch/library_errcom.c</name>
    <line>82</line>
    <line>110</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_habo.c</name>
    <line>86</line>
    <line>87</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_order.c</name>
    <line>271</line>
    <line>272</line>
    <line>273</line>
    <line>274</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_part_ovl.c</name>
    <line>166</line>
    <line>167</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_map.c</name>
    <line>293</line>
    <line>294</line>
    <line>295</line>
    <line>296</line>
    <line>371</line>
    <line>372</line>
    <line>373</line>
    <line>374</line>
    <line>375</line>
  </file>
  <file>
    <name>src/libscotch/vgraph_separate_vw.c</name>
    <line>86</line>
  </file>
  <file>
    <name>src/libscotch/graph_io.c</name>
    <line>108</line>
    <line>337</line>
  </file>
  <file>
    <name>src/scotch/gscat.c</name>
    <line>146</line>
  </file>
  <file>
    <name>src/scotch/gout_o.c</name>
    <line>818</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>673</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>fprintf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/libscotch/dgraph_io_save.c</name>
    <line>121</line>
    <line>139</line>
    <line>141</line>
    <line>143</line>
    <line>149</line>
    <line>150</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_mmkt.c</name>
    <line>280</line>
    <line>290</line>
    <line>306</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_dump.c</name>
    <line>91</line>
    <line>111</line>
  </file>
  <file>
    <name>src/libscotch/arch_hcub.c</name>
    <line>134</line>
    <line>349</line>
  </file>
  <file>
    <name>src/libscotch/arch_deco2.c</name>
    <line>299</line>
    <line>308</line>
    <line>317</line>
    <line>339</line>
    <line>348</line>
    <line>354</line>
    <line>783</line>
  </file>
  <file>
    <name>src/libscotch/graph_dump.c</name>
    <line>97</line>
    <line>107</line>
    <line>115</line>
    <line>119</line>
    <line>122</line>
    <line>130</line>
    <line>133</line>
    <line>164</line>
    <line>169</line>
  </file>
  <file>
    <name>src/libscotch/dorder_io.c</name>
    <line>194</line>
    <line>206</line>
    <line>217</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io.c</name>
    <line>338</line>
    <line>383</line>
    <line>385</line>
    <line>386</line>
  </file>
  <file>
    <name>src/libscotch/dorder_io_block.c</name>
    <line>94</line>
  </file>
  <file>
    <name>src/libscotch/arch_sub.c</name>
    <line>154</line>
    <line>162</line>
    <line>785</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io_scot.c</name>
    <line>229</line>
    <line>236</line>
    <line>242</line>
    <line>249</line>
  </file>
  <file>
    <name>src/libscotch/dmapping_io.c</name>
    <line>143</line>
    <line>199</line>
    <line>227</line>
  </file>
  <file>
    <name>src/libscotch/arch_dist.c</name>
    <line>119</line>
  </file>
  <file>
    <name>src/libscotch/mapping_io.c</name>
    <line>223</line>
    <line>230</line>
  </file>
  <file>
    <name>src/libscotch/order_io.c</name>
    <line>145</line>
    <line>156</line>
    <line>167</line>
    <line>202</line>
    <line>226</line>
    <line>261</line>
    <line>287</line>
  </file>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>218</line>
  </file>
  <file>
    <name>src/libscotch/arch_vcmplt.c</name>
    <line>218</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_chac.c</name>
    <line>285</line>
    <line>296</line>
    <line>300</line>
    <line>309</line>
    <line>313</line>
    <line>318</line>
  </file>
  <file>
    <name>src/libscotch/hgraph_dump.c</name>
    <line>88</line>
    <line>94</line>
    <line>100</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_scot.c</name>
    <line>233</line>
    <line>240</line>
    <line>246</line>
    <line>253</line>
  </file>
  <file>
    <name>src/libscotch/parser.c</name>
    <line>250</line>
    <line>606</line>
  </file>
  <file>
    <name>src/libscotch/graph_list.c</name>
    <line>230</line>
  </file>
  <file>
    <name>src/libscotch/vdgraph_separate_df.c</name>
    <line>365</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map_io.c</name>
    <line>212</line>
    <line>218</line>
  </file>
  <file>
    <name>src/libscotch/dgraph_view.c</name>
    <line>101</line>
    <line>110</line>
    <line>116</line>
    <line>120</line>
    <line>123</line>
    <line>130</line>
    <line>137</line>
    <line>142</line>
    <line>160</line>
  </file>
  <file>
    <name>src/libscotch/arch_tleaf.c</name>
    <line>197</line>
    <line>204</line>
    <line>563</line>
    <line>776</line>
    <line>783</line>
  </file>
  <file>
    <name>src/libscotch/arch_deco.c</name>
    <line>397</line>
    <line>405</line>
    <line>416</line>
    <line>567</line>
  </file>
  <file>
    <name>src/libscotch/arch_mesh.c</name>
    <line>147</line>
    <line>439</line>
    <line>711</line>
    <line>718</line>
    <line>1027</line>
  </file>
  <file>
    <name>src/libscotch/vgraph_separate_vw.c</name>
    <line>96</line>
    <line>100</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map_view.c</name>
    <line>369</line>
    <line>373</line>
    <line>447</line>
    <line>504</line>
    <line>507</line>
    <line>511</line>
    <line>527</line>
    <line>557</line>
    <line>564</line>
    <line>575</line>
    <line>783</line>
    <line>785</line>
    <line>791</line>
  </file>
  <file>
    <name>src/libscotch/arch_cmpltw.c</name>
    <line>277</line>
    <line>287</line>
    <line>498</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_map_view.c</name>
    <line>224</line>
    <line>228</line>
    <line>298</line>
    <line>359</line>
    <line>362</line>
    <line>366</line>
    <line>380</line>
  </file>
  <file>
    <name>src/libscotch/arch_cmplt.c</name>
    <line>135</line>
    <line>369</line>
  </file>
  <file>
    <name>src/libscotch/common_integer.c</name>
    <line>136</line>
    <line>352</line>
    <line>372</line>
  </file>
  <file>
    <name>src/libscotch/graph_io.c</name>
    <line>345</line>
    <line>359</line>
    <line>361</line>
    <line>363</line>
    <line>371</line>
    <line>373</line>
  </file>
  <file>
    <name>src/libscotch/arch_vhcub.c</name>
    <line>218</line>
  </file>
  <file>
    <name>src/esmumps/esmumps.c</name>
    <line>163</line>
  </file>
  <file>
    <name>src/scotch/dgord.c</name>
    <line>257</line>
    <line>258</line>
    <line>259</line>
  </file>
  <file>
    <name>src/scotch/dgtst.c</name>
    <line>178</line>
    <line>179</line>
    <line>180</line>
    <line>213</line>
    <line>215</line>
    <line>217</line>
    <line>219</line>
    <line>221</line>
  </file>
  <file>
    <name>src/scotch/gscat.c</name>
    <line>118</line>
    <line>119</line>
    <line>120</line>
    <line>203</line>
    <line>279</line>
  </file>
  <file>
    <name>src/scotch/gtst.c</name>
    <line>141</line>
    <line>142</line>
    <line>143</line>
    <line>163</line>
    <line>165</line>
    <line>167</line>
    <line>169</line>
    <line>171</line>
  </file>
  <file>
    <name>src/scotch/amk_grf.c</name>
    <line>159</line>
    <line>160</line>
    <line>161</line>
  </file>
  <file>
    <name>src/scotch/amk_hy.c</name>
    <line>137</line>
    <line>138</line>
    <line>139</line>
    <line>152</line>
    <line>157</line>
    <line>165</line>
  </file>
  <file>
    <name>src/scotch/gcv.c</name>
    <line>191</line>
    <line>192</line>
    <line>193</line>
  </file>
  <file>
    <name>src/scotch/gotst.c</name>
    <line>142</line>
    <line>143</line>
    <line>144</line>
    <line>253</line>
  </file>
  <file>
    <name>src/scotch/mmk_m3.c</name>
    <line>144</line>
    <line>145</line>
    <line>146</line>
    <line>161</line>
    <line>172</line>
    <line>193</line>
    <line>196</line>
    <line>201</line>
    <line>204</line>
    <line>211</line>
    <line>214</line>
    <line>219</line>
    <line>222</line>
    <line>232</line>
    <line>238</line>
    <line>248</line>
  </file>
  <file>
    <name>src/scotch/amk_m2.c</name>
    <line>177</line>
    <line>178</line>
    <line>179</line>
    <line>204</line>
    <line>208</line>
    <line>215</line>
  </file>
  <file>
    <name>src/scotch/gmk_msh.c</name>
    <line>129</line>
    <line>130</line>
    <line>131</line>
  </file>
  <file>
    <name>src/scotch/gmk_m2.c</name>
    <line>183</line>
    <line>184</line>
    <line>185</line>
    <line>204</line>
    <line>234</line>
    <line>259</line>
    <line>264</line>
    <line>303</line>
  </file>
  <file>
    <name>src/scotch/gmtst.c</name>
    <line>136</line>
    <line>137</line>
    <line>138</line>
  </file>
  <file>
    <name>src/scotch/amk_p2.c</name>
    <line>125</line>
    <line>126</line>
    <line>127</line>
    <line>137</line>
  </file>
  <file>
    <name>src/scotch/dggath.c</name>
    <line>167</line>
    <line>168</line>
    <line>169</line>
  </file>
  <file>
    <name>src/scotch/amk_ccc.c</name>
    <line>145</line>
    <line>146</line>
    <line>147</line>
    <line>164</line>
    <line>182</line>
    <line>214</line>
    <line>217</line>
  </file>
  <file>
    <name>src/scotch/gord.c</name>
    <line>211</line>
    <line>212</line>
    <line>213</line>
  </file>
  <file>
    <name>src/scotch/mcv.c</name>
    <line>164</line>
    <line>165</line>
    <line>166</line>
  </file>
  <file>
    <name>src/scotch/dgmap.c</name>
    <line>309</line>
    <line>310</line>
    <line>311</line>
  </file>
  <file>
    <name>src/scotch/gdump.c</name>
    <line>126</line>
    <line>127</line>
    <line>128</line>
  </file>
  <file>
    <name>src/scotch/gmk_m3.c</name>
    <line>158</line>
    <line>159</line>
    <line>160</line>
    <line>175</line>
    <line>186</line>
    <line>191</line>
    <line>194</line>
    <line>197</line>
    <line>200</line>
    <line>203</line>
    <line>206</line>
    <line>214</line>
    <line>230</line>
    <line>233</line>
    <line>236</line>
    <line>239</line>
    <line>242</line>
    <line>245</line>
    <line>254</line>
    <line>260</line>
  </file>
  <file>
    <name>src/scotch/gmk_ub2.c</name>
    <line>152</line>
    <line>153</line>
    <line>154</line>
    <line>167</line>
    <line>180</line>
  </file>
  <file>
    <name>src/scotch/amk_fft2.c</name>
    <line>142</line>
    <line>143</line>
    <line>144</line>
    <line>160</line>
    <line>183</line>
    <line>228</line>
    <line>231</line>
  </file>
  <file>
    <name>src/scotch/mord.c</name>
    <line>183</line>
    <line>184</line>
    <line>185</line>
  </file>
  <file>
    <name>src/scotch/gmk_hy.c</name>
    <line>134</line>
    <line>135</line>
    <line>136</line>
    <line>149</line>
    <line>154</line>
    <line>157</line>
  </file>
  <file>
    <name>src/scotch/gout_o.c</name>
    <line>373</line>
    <line>473</line>
    <line>486</line>
    <line>490</line>
    <line>847</line>
    <line>850</line>
    <line>866</line>
    <line>878</line>
    <line>894</line>
    <line>937</line>
    <line>1049</line>
    <line>1057</line>
    <line>1065</line>
    <line>1066</line>
    <line>1069</line>
    <line>1074</line>
    <line>1080</line>
  </file>
  <file>
    <name>src/scotch/gmap.c</name>
    <line>329</line>
    <line>330</line>
    <line>331</line>
  </file>
  <file>
    <name>src/scotch/gbase.c</name>
    <line>132</line>
    <line>133</line>
    <line>134</line>
  </file>
  <file>
    <name>src/scotch/atst.c</name>
    <line>135</line>
    <line>136</line>
    <line>137</line>
    <line>193</line>
    <line>195</line>
  </file>
  <file>
    <name>src/scotch/mmk_m2.c</name>
    <line>143</line>
    <line>144</line>
    <line>145</line>
    <line>159</line>
    <line>167</line>
    <line>181</line>
    <line>184</line>
    <line>189</line>
    <line>192</line>
    <line>200</line>
    <line>205</line>
    <line>212</line>
  </file>
  <file>
    <name>src/scotch/acpl.c</name>
    <line>126</line>
    <line>127</line>
    <line>128</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>195</line>
    <line>196</line>
    <line>197</line>
  </file>
  <file>
    <name>src/scotch/dgscat.c</name>
    <line>164</line>
    <line>165</line>
    <line>166</line>
  </file>
  <file>
    <name>src/scotch/mtst.c</name>
    <line>131</line>
    <line>132</line>
    <line>133</line>
    <line>152</line>
    <line>154</line>
    <line>156</line>
    <line>158</line>
    <line>160</line>
    <line>162</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>fscanf</type>
  <message>
    Check to be sure that the format string passed as argument 2 to this
    function call does not come from an untrusted source that could have added
    formatting characters that the code is not prepared to handle.
    Additionally, the format string could contain `%s' without precision that
    could result in a buffer overflow.
  </message>
  <file>
    <name>src/libscotch/arch.c</name>
    <line>195</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map_io.c</name>
    <line>101</line>
    <line>122</line>
  </file>
  <file>
    <name>src/libscotch/common_integer.c</name>
    <line>301</line>
    <line>327</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>355</line>
    <line>379</line>
    <line>403</line>
    <line>427</line>
    <line>573</line>
    <line>591</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>sprintf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/libscotch/library_graph_order.c</name>
    <line>515</line>
    <line>517</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map.c</name>
    <line>666</line>
    <line>667</line>
    <line>732</line>
  </file>
  <file>
    <name>src/libscotch/common_file.c</name>
    <line>96</line>
    <line>149</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_order.c</name>
    <line>285</line>
    <line>286</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_map.c</name>
    <line>309</line>
    <line>385</line>
    <line>389</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>sprintf</type>
  <message>
    Check to be sure that the format string passed as argument 2 to this
    function call does not come from an untrusted source that could have added
    formatting characters that the code is not prepared to handle.
    Additionally, the format string could contain `%s' without precision that
    could result in a buffer overflow.
  </message>
  <file>
    <name>src/libscotch/library_graph_order.c</name>
    <line>515</line>
    <line>517</line>
  </file>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>161</line>
    <line>347</line>
    <line>355</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map.c</name>
    <line>666</line>
    <line>667</line>
    <line>732</line>
  </file>
  <file>
    <name>src/libscotch/common_file.c</name>
    <line>96</line>
    <line>149</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_order.c</name>
    <line>285</line>
    <line>286</line>
  </file>
  <file>
    <name>src/libscotch/library_dgraph_map.c</name>
    <line>309</line>
    <line>385</line>
    <line>389</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>vfprintf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/libscotch/library_error_exit.c</name>
    <line>133</line>
    <line>176</line>
  </file>
  <file>
    <name>src/libscotch/library_error.c</name>
    <line>131</line>
    <line>168</line>
  </file>
  <file>
    <name>src/libscotch/common_error.c</name>
    <line>97</line>
    <line>119</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>getenv</type>
  <message>
    Environment variables are highly untrustable input. They may be of any length, and contain any data. Do not make any assumptions regarding content or length. If at all possible avoid using them, and if it is necessary, sanitize them and truncate them to a reasonable length.
  </message>
  <file>
    <name>src/libscotch/common.c</name>
    <line>85</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <message>
    Check to be sure that argument 2 passed to this function call will not
    copy more data than can be handled, resulting in a buffer overflow.
  </message>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>346</line>
    <line>354</line>
  </file>
  <file>
    <name>src/libscotch/library_graph_map.c</name>
    <line>669</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>vsprintf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/libscotch/library_errcom.c</name>
    <line>88</line>
    <line>116</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>vsprintf</type>
  <message>
    Check to be sure that the format string passed as argument 2 to this
    function call does not come from an untrusted source that could have added
    formatting characters that the code is not prepared to handle.
    Additionally, the format string could contain `%s' without precision that
    could result in a buffer overflow.
  </message>
  <file>
    <name>src/libscotch/library_errcom.c</name>
    <line>88</line>
    <line>116</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>fscanf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/libscotch/library_graph_map_io.c</name>
    <line>101</line>
    <line>122</line>
  </file>
  <file>
    <name>src/libscotch/common_integer.c</name>
    <line>301</line>
    <line>327</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>355</line>
    <line>379</line>
    <line>403</line>
    <line>427</line>
    <line>573</line>
    <line>591</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>scanf</type>
  <message>
    Check to be sure that the format string passed as argument 2 to this
    function call does not come from an untrusted source that could have added
    formatting characters that the code is not prepared to handle.
    Additionally, the format string could contain `%s' without precision that
    could result in a buffer overflow.
  </message>
  <file>
    <name>src/scotch/dgord.c</name>
    <line>298</line>
  </file>
  <file>
    <name>src/scotch/dgtst.c</name>
    <line>195</line>
  </file>
  <file>
    <name>src/scotch/dggath.c</name>
    <line>184</line>
  </file>
  <file>
    <name>src/scotch/dgmap.c</name>
    <line>359</line>
  </file>
  <file>
    <name>src/scotch/dgscat.c</name>
    <line>181</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_band.c</name>
    <line>125</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_check.c</name>
    <line>116</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_induce.c</name>
    <line>123</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_redist.c</name>
    <line>118</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_grow.c</name>
    <line>129</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_coarsen.c</name>
    <line>123</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>sscanf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 2 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>725</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>sscanf</type>
  <message>
    Check to be sure that the format string passed as argument 2 to this
    function call does not come from an untrusted source that could have added
    formatting characters that the code is not prepared to handle.
    Additionally, the format string could contain `%s' without precision that
    could result in a buffer overflow.
  </message>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>725</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>High</severity>
  <type>printf</type>
  <message>
    Check to be sure that the non-constant format string passed as argument 1 
    to this function call does not come from an untrusted source that could
    have added formatting characters that the code is not prepared to handle.
  </message>
  <file>
    <name>src/check/test_scotch_context.c</name>
    <line>108</line>
    <line>121</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_coarsen.c</name>
    <line>276</line>
    <line>292</line>
    <line>304</line>
    <line>319</line>
    <line>339</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Medium</severity>
  <type>fgetc</type>
  <message>
    Check buffer boundaries if calling this function in a loop 
and make sure you are not in danger of writing past the allocated space.
  </message>
  <file>
    <name>src/libscotch/graph_io_mmkt.c</name>
    <line>132</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Medium</severity>
  <type>read</type>
  <message>
    Check buffer boundaries if calling this function in a loop 
and make sure you are not in danger of writing past the allocated space.
  </message>
  <file>
    <name>src/libscotch/common_file_compress.c</name>
    <line>294</line>
    <line>333</line>
    <line>384</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Medium</severity>
  <type>getc</type>
  <message>
    Check buffer boundaries if calling this function in a loop 
and make sure you are not in danger of writing past the allocated space.
  </message>
  <file>
    <name>src/libscotch/graph_io_chac.c</name>
    <line>102</line>
    <line>105</line>
    <line>119</line>
    <line>175</line>
    <line>178</line>
    <line>207</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io_habo.c</name>
    <line>135</line>
    <line>145</line>
    <line>192</line>
    <line>195</line>
    <line>224</line>
    <line>227</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_habo.c</name>
    <line>158</line>
    <line>168</line>
    <line>218</line>
    <line>223</line>
    <line>224</line>
    <line>227</line>
    <line>232</line>
    <line>256</line>
    <line>261</line>
    <line>262</line>
    <line>265</line>
    <line>269</line>
  </file>
  <file>
    <name>src/libscotch/common_integer.c</name>
    <line>93</line>
    <line>100</line>
    <line>104</line>
    <line>113</line>
  </file>
  <file>
    <name>src/check/test_common_random.c</name>
    <line>180</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Medium</severity>
  <type>realloc</type>
  <message>
    Don't use on memory intended to be secure, because the old structure will not be zeroed out.
  </message>
  <file>
    <name>src/libscotch/common_memory.c</name>
    <line>344</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Medium</severity>
  <type>tmpfile</type>
  <message>
    Many calls for generating temporary file names are 
insecure (susceptible to race conditions).  Use a securely generated file
name, for example, by pulling 64 bits of randomness from /dev/random, base 
64 encoding it and using that as a file suffix.
  </message>
  <file>
    <name>src/check/test_scotch_graph_order.c</name>
    <line>117</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_map.c</name>
    <line>154</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>fgets</type>
  <message>
    Double check that your buffer is as big as you specify.
When using functions that accept a number n of bytes to copy, such as 
strncpy, be aware that if the dest buffer size = n it may not NULL-terminate 
the string.
  </message>
  <file>
    <name>src/libscotch/graph_io_mmkt.c</name>
    <line>115</line>
    <line>133</line>
    <line>181</line>
  </file>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>323</line>
  </file>
  <file>
    <name>src/libscotch/mesh_io_habo.c</name>
    <line>102</line>
    <line>103</line>
    <line>104</line>
    <line>105</line>
  </file>
  <file>
    <name>src/libscotch/graph_io_habo.c</name>
    <line>123</line>
    <line>124</line>
    <line>125</line>
    <line>126</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>fork</type>
  <message>
    Remember that sensitive data get copied on fork.  For example, a random
      number generator's internal state will get duplicated, and the child
      may start outputting identical number streams.
  </message>
  <file>
    <name>src/libscotch/common_stub.c</name>
    <line>74</line>
  </file>
  <file>
    <name>src/libscotch/common_file_compress.c</name>
    <line>248</line>
  </file>
  <file>
    <name>src/libscotch/common_file_decompress.c</name>
    <line>225</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>Static Global Buffer</type>
  <message>
    Extra care should be taken to ensure that character arrays that are
    allocated with a static size are used safely.  This appears to be a
    global allocation and is less dangerous than a similar one on the stack.
    Extra caution is still advised, however.
  </message>
  <file>
    <name>src/libscotch/library_error_exit.c</name>
    <line>71</line>
  </file>
  <file>
    <name>src/libscotch/library_error.c</name>
    <line>69</line>
  </file>
  <file>
    <name>src/libscotch/common_error.c</name>
    <line>63</line>
  </file>
  <file>
    <name>src/libscotch/common_memory.c</name>
    <line>82</line>
  </file>
  <file>
    <name>src/libscotch/parser.c</name>
    <line>553</line>
    <line>554</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>strlen</type>
  <message>
    This function does not properly handle non-NULL terminated
strings.  This does not result in exploitable code, but can lead to access 
violations.
  </message>
  <file>
    <name>src/libscotch/library_error_exit.c</name>
    <line>89</line>
  </file>
  <file>
    <name>src/libscotch/common_file_compress.c</name>
    <line>142</line>
    <line>146</line>
  </file>
  <file>
    <name>src/libscotch/library_error.c</name>
    <line>87</line>
  </file>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>327</line>
    <line>340</line>
    <line>348</line>
  </file>
  <file>
    <name>src/libscotch/common_string.c</name>
    <line>79</line>
    <line>105</line>
    <line>106</line>
  </file>
  <file>
    <name>src/libscotch/common_file.c</name>
    <line>89</line>
  </file>
  <file>
    <name>src/libscotch/common_file_decompress.c</name>
    <line>119</line>
    <line>123</line>
  </file>
  <file>
    <name>src/scotch/gout_o.c</name>
    <line>834</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>685</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>strncpy</type>
  <message>
    Double check that your buffer is as big as you specify.
When using functions that accept a number n of bytes to copy, such as 
strncpy, be aware that if the dest buffer size = n it may not NULL-terminate 
the string. Also, consider using strlcpy() instead, if it is avaialable to you.
  </message>
  <file>
    <name>src/libscotch/library_error_exit.c</name>
    <line>98</line>
  </file>
  <file>
    <name>src/libscotch/library_error.c</name>
    <line>96</line>
  </file>
  <file>
    <name>src/libscotch/library_arch_f.c</name>
    <line>210</line>
  </file>
  <file>
    <name>src/libscotch/common_error.c</name>
    <line>75</line>
  </file>
  <file>
    <name>src/scotch/gout_o.c</name>
    <line>832</line>
  </file>
  <file>
    <name>src/scotch/gout_c.c</name>
    <line>706</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>fixed size local buffer</type>
  <message>
    A potential race condition vulnerability exists here.  Normally a call
    to this function is vulnerable only when a match check precedes it.  No
    check was detected, however one could still exist that could not be
    detected.
  </message>
  <file>
    <name>src/libscotch/dummysizes.c</name>
    <line>232</line>
  </file>
  <file>
    <name>src/libscotch/common_file.c</name>
    <line>216</line>
  </file>
  <file>
    <name>src/libscotch/vgraph_separate_vw.c</name>
    <line>91</line>
  </file>
  <file>
    <name>src/esmumps/main_esmumps.c</name>
    <line>95</line>
  </file>
  <file>
    <name>src/scotch/gscat.c</name>
    <line>194</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_band.c</name>
    <line>141</line>
    <line>188</line>
  </file>
  <file>
    <name>src/check/test_scotch_mesh_graph.c</name>
    <line>91</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_check.c</name>
    <line>132</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_induce.c</name>
    <line>139</line>
  </file>
  <file>
    <name>src/check/test_libmetis.c</name>
    <line>110</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_induce.c</name>
    <line>95</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_diam.c</name>
    <line>88</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_redist.c</name>
    <line>138</line>
  </file>
  <file>
    <name>src/check/test_scotch_arch.c</name>
    <line>146</line>
    <line>163</line>
  </file>
  <file>
    <name>src/check/test_scotch_context.c</name>
    <line>221</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_coarsen.c</name>
    <line>249</line>
  </file>
  <file>
    <name>src/check/test_common_random.c</name>
    <line>105</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_grow.c</name>
    <line>145</line>
    <line>204</line>
  </file>
  <file>
    <name>src/check/test_libesmumps.c</name>
    <line>100</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_map_copy.c</name>
    <line>98</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_part_ovl.c</name>
    <line>120</line>
    <line>201</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_order.c</name>
    <line>94</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_map.c</name>
    <line>105</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_color.c</name>
    <line>91</line>
  </file>
  <file>
    <name>src/check/test_scotch_arch_deco.c</name>
    <line>99</line>
    <line>117</line>
    <line>172</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_dump.c</name>
    <line>94</line>
  </file>
  <file>
    <name>src/check/test_multilib.c</name>
    <line>90</line>
    <line>102</line>
  </file>
  <file>
    <name>src/check/test_scotch_dgraph_coarsen.c</name>
    <line>139</line>
  </file>
</vulnerability>
<vulnerability>
  <severity>Low</severity>
  <type>memcpy</type>
  <message>
    Double check that your buffer is as big as you specify.
When using functions that accept a number n of bytes to copy, such as 
strncpy, be aware that if the dest buffer size = n it may not NULL-terminate 
the string.
  </message>
  <file>
    <name>src/check/test_libesmumps.c</name>
    <line>123</line>
    <line>134</line>
    <line>138</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_map_copy.c</name>
    <line>147</line>
  </file>
  <file>
    <name>src/check/test_scotch_graph_map.c</name>
    <line>202</line>
  </file>
</vulnerability>
<timing>
<total_lines>125746</total_lines>
<total_time>0.053346</total_time>
<lines_per_second>2357177</lines_per_second>
</timing>
</rats_output>
```

## 2.功能性测试

### 2.1.所选测试案例

scotch内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host- build]# root@zubinshuo-PC 11:46:26 ~/scotch |main ↑1 ✓| → tree src/check/
check
├── CMakeLists.txt
├── data
│   ├── bump_b100000.grf
│   ├── bump_b1.grf
│   ├── bump.grf
│   ├── bump_imbal_32.grf
│   ├── bump_old.map
│   ├── bump.xyz
│   ├── compress-coarsen.grf
│   ├── cube_8_d3.grf
│   ├── cube_8.msh
│   ├── m16x16_b100000.grf
│   ├── m16x16_b1.grf
│   ├── m16x16.grf
│   ├── m4x4_b100000.grf
│   ├── m4x4_b1_elv.grf
│   ├── m4x4_b1_ev.grf
│   ├── m4x4_b1.grf
│   ├── m4x4.grf
│   ├── m4x4_vertlist.txt
│   ├── nocoarsen.grf
│   ├── p2-p2.grf
│   ├── ship001.msh
│   ├── small_0.grf
│   ├── small_1.grf
│   ├── small_2.grf
│   ├── small_3.grf
│   ├── small_55_d1.grf
│   ├── small_55_d2.grf
│   ├── small_55.msh
│   └── small.grf
├── Makefile
├── test_common_file_compress.c
├── test_common_random.c
├── test_common_thread.c
├── test_fibo.c
├── test_libesmumps.c
├── test_libmetis.c
├── test_libmetis_dual.c
├── test_libmetis_dual_f.f90
├── test_multilib.c
├── test_scotch_arch.c
├── test_scotch_arch_deco.c
├── test_scotch_context.c
├── test_scotch_dgraph_band.c
├── test_scotch_dgraph_check.c
├── test_scotch_dgraph_coarsen.c
├── test_scotch_dgraph_grow.c
├── test_scotch_dgraph_induce.c
├── test_scotch_dgraph_redist.c
├── test_scotch_graph_coarsen.c
├── test_scotch_graph_color.c
├── test_scotch_graph_diam.c
├── test_scotch_graph_dump.c
├── test_scotch_graph_induce.c
├── test_scotch_graph_map.c
├── test_scotch_graph_map_copy.c
├── test_scotch_graph_order.c
├── test_scotch_graph_part_ovl.c
├── test_scotch_mesh_graph.c
├── test_strat_par.c
└── test_strat_seq.c

1 directory, 61 files
...

```

在项目根目录下执行命令来运行单元测试和确定性测试

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
make test
```

### 2.2.运行结果

```bash
[root@host- build]# make test
Running tests...
Test project /root/hpcrunner/tmp/scotch-v7.0.1/build
        Start   1: test_common_file_compress_bz2
  1/138 Test   #1: test_common_file_compress_bz2 .............   Passed    0.05 sec
        Start   2: test_common_file_compress_gz
  2/138 Test   #2: test_common_file_compress_gz ..............   Passed    0.10 sec
        Start   3: test_common_file_compress_lzma
  3/138 Test   #3: test_common_file_compress_lzma ............   Passed    0.15 sec
        Start   4: test_common_random_0
  4/138 Test   #4: test_common_random_0 ......................   Passed    2.00 sec
        Start   5: test_common_random_1
  5/138 Test   #5: test_common_random_1 ......................   Passed    0.00 sec
        Start   6: test_common_thread
  6/138 Test   #6: test_common_thread ........................   Passed    0.00 sec
        Start   7: test_fibo
  7/138 Test   #7: test_fibo .................................   Passed    0.00 sec
        Start   8: test_libesmumps_1
  8/138 Test   #8: test_libesmumps_1 .........................   Passed    0.08 sec
        Start   9: test_libesmumps_2
  9/138 Test   #9: test_libesmumps_2 .........................   Passed    0.13 sec
        Start  10: test_libmetisv3_1
 10/138 Test  #10: test_libmetisv3_1 .........................   Passed    0.27 sec
        Start  11: test_libmetisv3_2
 11/138 Test  #11: test_libmetisv3_2 .........................   Passed    0.27 sec
        Start  12: test_libmetisv3_3
 12/138 Test  #12: test_libmetisv3_3 .........................   Passed    0.27 sec
        Start  13: test_libmetis_dualv3
 13/138 Test  #13: test_libmetis_dualv3 ......................   Passed    0.03 sec
        Start  14: test_libmetis_dual_f_v3
 14/138 Test  #14: test_libmetis_dual_f_v3 ...................   Passed    0.02 sec
        Start  15: test_libmetisv5_1
 15/138 Test  #15: test_libmetisv5_1 .........................   Passed    0.12 sec
        Start  16: test_libmetisv5_2
 16/138 Test  #16: test_libmetisv5_2 .........................   Passed    0.12 sec
        Start  17: test_libmetisv5_3
 17/138 Test  #17: test_libmetisv5_3 .........................   Passed    0.12 sec
        Start  18: test_libmetis_dualv5
 18/138 Test  #18: test_libmetis_dualv5 ......................   Passed    0.01 sec
        Start  19: test_libmetis_dual_f_v5
 19/138 Test  #19: test_libmetis_dual_f_v5 ...................   Passed    0.01 sec
        Start  20: test_scotch_arch
 20/138 Test  #20: test_scotch_arch ..........................   Passed    0.00 sec
        Start  21: test_scotch_arch_deco
 21/138 Test  #21: test_scotch_arch_deco .....................   Passed    0.02 sec
        Start  22: test_scotch_context
 22/138 Test  #22: test_scotch_context .......................   Passed    0.00 sec
        Start  23: test_scotch_graph_coarsen_1
 23/138 Test  #23: test_scotch_graph_coarsen_1 ...............   Passed    0.01 sec
        Start  24: test_scotch_graph_coarsen_2
 24/138 Test  #24: test_scotch_graph_coarsen_2 ...............   Passed    0.02 sec
        Start  25: test_scotch_graph_color_1
 25/138 Test  #25: test_scotch_graph_color_1 .................   Passed    0.01 sec
        Start  26: test_scotch_graph_color_2
 26/138 Test  #26: test_scotch_graph_color_2 .................   Passed    0.01 sec
        Start  27: test_scotch_graph_diam_1
 27/138 Test  #27: test_scotch_graph_diam_1 ..................   Passed    0.01 sec
        Start  28: test_scotch_graph_diam_2
 28/138 Test  #28: test_scotch_graph_diam_2 ..................   Passed    0.00 sec
        Start  29: test_scotch_graph_diam_3
 29/138 Test  #29: test_scotch_graph_diam_3 ..................   Passed    0.00 sec
        Start  30: test_scotch_graph_diam_4
 30/138 Test  #30: test_scotch_graph_diam_4 ..................   Passed    0.01 sec
        Start  31: test_scotch_graph_induce_1
 31/138 Test  #31: test_scotch_graph_induce_1 ................   Passed    0.01 sec
        Start  32: test_scotch_graph_induce_2
 32/138 Test  #32: test_scotch_graph_induce_2 ................   Passed    0.01 sec
        Start  33: test_scotch_graph_1
 33/138 Test  #33: test_scotch_graph_1 .......................   Passed    0.01 sec
        Start  34: test_scotch_graph_2
 34/138 Test  #34: test_scotch_graph_2 .......................   Passed    0.00 sec
        Start  35: test_scotch_graph_3
 35/138 Test  #35: test_scotch_graph_3 .......................   Passed    0.09 sec
        Start  36: test_scotch_graph_4
 36/138 Test  #36: test_scotch_graph_4 .......................   Passed    0.09 sec
        Start  37: test_scotch_graph_map_copy_1
 37/138 Test  #37: test_scotch_graph_map_copy_1 ..............   Passed    0.10 sec
        Start  38: test_scotch_graph_map_copy_2
 38/138 Test  #38: test_scotch_graph_map_copy_2 ..............   Passed    0.10 sec
        Start  39: test_scotch_graph_order_1
 39/138 Test  #39: test_scotch_graph_order_1 .................   Passed    0.09 sec
        Start  40: test_scotch_graph_order_2
 40/138 Test  #40: test_scotch_graph_order_2 .................   Passed    0.09 sec
        Start  41: test_scotch_graph_part_ovl_1
 41/138 Test  #41: test_scotch_graph_part_ovl_1 ..............   Passed    0.00 sec
        Start  42: test_scotch_graph_part_ovl_2
 42/138 Test  #42: test_scotch_graph_part_ovl_2 ..............   Passed    0.00 sec
        Start  43: test_scotch_mesh_graph
 43/138 Test  #43: test_scotch_mesh_graph ....................   Passed    0.10 sec
        Start  44: test_strat_seq
 44/138 Test  #44: test_strat_seq ............................   Passed    0.00 sec
        Start  45: test_strat_par
 45/138 Test  #45: test_strat_par ............................   Passed    0.00 sec
        Start  46: test_scotch_dgraph_band_bump
 46/138 Test  #46: test_scotch_dgraph_band_bump ..............   Passed    0.34 sec
        Start  47: test_scotch_dgraph_band_bump_b100000
 47/138 Test  #47: test_scotch_dgraph_band_bump_b100000 ......   Passed    0.18 sec
        Start  48: test_scotch_dgraph_coarsen_bump
 48/138 Test  #48: test_scotch_dgraph_coarsen_bump ...........   Passed    0.18 sec
        Start  49: test_scotch_dgraph_coarsen_bump_b100000
 49/138 Test  #49: test_scotch_dgraph_coarsen_bump_b100000 ...   Passed    0.18 sec
        Start  50: test_scotch_dgraph_coarsen_m4x4_b1
 50/138 Test  #50: test_scotch_dgraph_coarsen_m4x4_b1 ........   Passed    0.16 sec
        Start  51: test_scotch_dgraph_check_bump
 51/138 Test  #51: test_scotch_dgraph_check_bump .............   Passed    0.17 sec
        Start  52: test_scotch_dgraph_check_bump_b100000
 52/138 Test  #52: test_scotch_dgraph_check_bump_b100000 .....   Passed    0.18 sec
        Start  53: test_scotch_dgraph_grow_bump
 53/138 Test  #53: test_scotch_dgraph_grow_bump ..............   Passed    0.17 sec
        Start  54: test_scotch_dgraph_grow_bump_b100000
 54/138 Test  #54: test_scotch_dgraph_grow_bump_b100000 ......   Passed    0.18 sec
        Start  55: test_scotch_dgraph_induce_bump
 55/138 Test  #55: test_scotch_dgraph_induce_bump ............   Passed    0.17 sec
        Start  56: test_scotch_dgraph_induce_bump_b100000
 56/138 Test  #56: test_scotch_dgraph_induce_bump_b100000 ....   Passed    0.18 sec
        Start  57: test_scotch_dgraph_redist_bump
 57/138 Test  #57: test_scotch_dgraph_redist_bump ............   Passed    0.18 sec
        Start  58: test_scotch_dgraph_redist_bump_b100000
 58/138 Test  #58: test_scotch_dgraph_redist_bump_b100000 ....   Passed    0.18 sec
        Start  59: amk_acpl
 59/138 Test  #59: amk_acpl ..................................   Passed    0.01 sec
        Start  60: amk_ccc
 60/138 Test  #60: amk_ccc ...................................   Passed    0.00 sec
        Start  61: amk_fft2
 61/138 Test  #61: amk_fft2 ..................................   Passed    0.00 sec
        Start  62: amk_hy
 62/138 Test  #62: amk_hy ....................................   Passed    0.00 sec
        Start  63: amk_m2
 63/138 Test  #63: amk_m2 ....................................   Passed    0.00 sec
        Start  64: amk_m2_mo
 64/138 Test  #64: amk_m2_mo .................................   Passed    0.00 sec
        Start  65: amk_p2
 65/138 Test  #65: amk_p2 ....................................   Passed    0.00 sec
        Start  66: amk_grf_m16x16
 66/138 Test  #66: amk_grf_m16x16 ............................   Passed    0.02 sec
        Start  67: amk_grf_m16x16_2
 67/138 Test  #67: amk_grf_m16x16_2 ..........................   Passed    0.00 sec
        Start  68: amk_grf_m4x4
 68/138 Test  #68: amk_grf_m4x4 ..............................   Passed    0.00 sec
        Start  69: amk_grf_m4x4_2
 69/138 Test  #69: amk_grf_m4x4_2 ............................   Passed    0.00 sec
        Start  70: atst_4x4x4
 70/138 Test  #70: atst_4x4x4 ................................   Passed    0.01 sec
        Start  71: test_gbase_1
 71/138 Test  #71: test_gbase_1 ..............................   Passed    0.01 sec
        Start  72: test_gbase_2
 72/138 Test  #72: test_gbase_2 ..............................   Passed    0.01 sec
        Start  73: test_gbase_3
 73/138 Test  #73: test_gbase_3 ..............................   Passed    0.01 sec
        Start  74: gmk_hy
 74/138 Test  #74: gmk_hy ....................................   Passed    0.00 sec
        Start  75: gmk_m2
 75/138 Test  #75: gmk_m2 ....................................   Passed    0.00 sec
        Start  76: gmk_m2_b1
 76/138 Test  #76: gmk_m2_b1 .................................   Passed    0.00 sec
        Start  77: gmk_m2_t
 77/138 Test  #77: gmk_m2_t ..................................   Passed    0.00 sec
        Start  78: gmk_m2_b1_t
 78/138 Test  #78: gmk_m2_b1_t ...............................   Passed    0.00 sec
        Start  79: gmk_m3
 79/138 Test  #79: gmk_m3 ....................................   Passed    0.00 sec
        Start  80: gmk_ub2
 80/138 Test  #80: gmk_ub2 ...................................   Passed    0.00 sec
        Start  81: gmk_msh_5_1
 81/138 Test  #81: gmk_msh_5_1 ...............................   Passed    0.01 sec
        Start  82: gmk_msh_5_4
 82/138 Test  #82: gmk_msh_5_4 ...............................   Passed    0.01 sec
        Start  83: gmk_msh_3_5_4_3
 83/138 Test  #83: gmk_msh_3_5_4_3 ...........................   Passed    0.01 sec
        Start  84: gmk_msh_ship001
 84/138 Test  #84: gmk_msh_ship001 ...........................   Passed    1.55 sec
        Start  85: gmk_msh_dual_1
 85/138 Test  #85: gmk_msh_dual_1 ............................   Passed    0.04 sec
        Start  86: gmk_msh_dual_2
 86/138 Test  #86: gmk_msh_dual_2 ............................   Passed    0.01 sec
        Start  87: gmk_msh_dual_3
 87/138 Test  #87: gmk_msh_dual_3 ............................   Passed    0.01 sec
        Start  88: mmk_m2_5_1
 88/138 Test  #88: mmk_m2_5_1 ................................   Passed    0.01 sec
        Start  89: mmk_m2_5_4
 89/138 Test  #89: mmk_m2_5_4 ................................   Passed    0.01 sec
        Start  90: mmk_m3_5_4_3
 90/138 Test  #90: mmk_m3_5_4_3 ..............................   Passed    0.01 sec
        Start  91: mcv_msh_5_1
 91/138 Test  #91: mcv_msh_5_1 ...............................   Passed    0.01 sec
        Start  92: mcv_msh_5_4
 92/138 Test  #92: mcv_msh_5_4 ...............................   Passed    0.01 sec
        Start  93: mcv_2_5_4_3
 93/138 Test  #93: mcv_2_5_4_3 ...............................   Passed    0.01 sec
        Start  94: mord_5_1
 94/138 Test  #94: mord_5_1 ..................................   Passed    0.01 sec
        Start  95: mord_5_4
 95/138 Test  #95: mord_5_4 ..................................   Passed    0.01 sec
        Start  96: mord_5_4_3
 96/138 Test  #96: mord_5_4_3 ................................   Passed    0.01 sec
        Start  97: mord_ship001
 97/138 Test  #97: mord_ship001 ..............................   Passed    1.79 sec
        Start  98: gmap_bump
 98/138 Test  #98: gmap_bump .................................   Passed    0.05 sec
        Start  99: gmap_small
 99/138 Test  #99: gmap_small ................................   Passed    0.01 sec
        Start 100: gord_bump
100/138 Test #100: gord_bump .................................   Passed    0.06 sec
        Start 101: gord_bump_b1
101/138 Test #101: gord_bump_b1 ..............................   Passed    0.06 sec
        Start 102: gord_cmplx
102/138 Test #102: gord_cmplx ................................   Passed    0.03 sec
        Start 103: gord_bump_imbal
103/138 Test #103: gord_bump_imbal ...........................   Passed    0.06 sec
        Start 104: gord_ship001
104/138 Test #104: gord_ship001 ..............................   Passed    0.96 sec
        Start 105: gotst_bump
105/138 Test #105: gotst_bump ................................   Passed    0.07 sec
        Start 106: gotst_bump_b1
106/138 Test #106: gotst_bump_b1 .............................   Passed    0.07 sec
        Start 107: gotst_bump_imbal_32
107/138 Test #107: gotst_bump_imbal_32 .......................   Passed    0.07 sec
        Start 108: gotst_ship001
108/138 Test #108: gotst_ship001 .............................   Passed    1.33 sec
        Start 109: gord_block_1
109/138 Test #109: gord_block_1 ..............................   Passed    0.00 sec
        Start 110: gord_block_2
110/138 Test #110: gord_block_2 ..............................   Passed    0.00 sec
        Start 111: gord_block_3
111/138 Test #111: gord_block_3 ..............................   Passed    0.00 sec
        Start 112: gout_1
112/138 Test #112: gout_1 ....................................   Passed    0.17 sec
        Start 113: gout_2
113/138 Test #113: gout_2 ....................................   Passed    0.14 sec
        Start 114: gout_3
114/138 Test #114: gout_3 ....................................   Passed    0.10 sec
        Start 115: gpart_1
115/138 Test #115: gpart_1 ...................................   Passed    0.05 sec
        Start 116: gpart_2
116/138 Test #116: gpart_2 ...................................   Passed    0.04 sec
        Start 117: gpart_cluster_1
117/138 Test #117: gpart_cluster_1 ...........................   Passed    0.54 sec
        Start 118: gpart_cluster_2
118/138 Test #118: gpart_cluster_2 ...........................   Passed    0.36 sec
        Start 119: gpart_overlap_1
119/138 Test #119: gpart_overlap_1 ...........................   Passed    0.04 sec
        Start 120: gpart_overlap_2
120/138 Test #120: gpart_overlap_2 ...........................   Passed    0.06 sec
        Start 121: gpart_overlap_3
121/138 Test #121: gpart_overlap_3 ...........................   Passed    0.03 sec
        Start 122: gpart_remap
122/138 Test #122: gpart_remap ...............................   Passed    0.08 sec
        Start 123: gscat
123/138 Test #123: gscat .....................................   Passed    0.00 sec
        Start 124: gtst
124/138 Test #124: gtst ......................................   Passed    0.02 sec
        Start 125: prg_full_1
125/138 Test #125: prg_full_1 ................................   Passed    0.06 sec
        Start 126: prg_full_2
126/138 Test #126: prg_full_2 ................................   Passed    0.02 sec
        Start 127: prg_full_3
127/138 Test #127: prg_full_3 ................................   Passed    0.01 sec
        Start 128: dgord_1
128/138 Test #128: dgord_1 ...................................   Passed    0.19 sec
        Start 129: dgord_2
129/138 Test #129: dgord_2 ...................................   Passed    0.20 sec
        Start 130: dgord_3
130/138 Test #130: dgord_3 ...................................   Passed    0.15 sec
        Start 131: dgpart_1
131/138 Test #131: dgpart_1 ..................................   Passed    0.20 sec
        Start 132: dgpart_2
132/138 Test #132: dgpart_2 ..................................   Passed    0.20 sec
        Start 133: dgpart_3
133/138 Test #133: dgpart_3 ..................................   Passed    0.16 sec
        Start 134: test_dgscat
134/138 Test #134: test_dgscat ...............................   Passed    0.31 sec
        Start 135: test_dgscat_b1
135/138 Test #135: test_dgscat_b1 ............................   Passed    0.30 sec
        Start 136: dgtst
136/138 Test #136: dgtst .....................................   Passed    0.15 sec
        Start 137: dfull_1
137/138 Test #137: dfull_1 ...................................   Passed    0.19 sec
        Start 138: dfull_2
138/138 Test #138: dfull_2 ...................................   Passed    0.19 sec

100% tests passed, 0 tests failed out of 138
```

测试结果

单元测试运行正常，说明各类型函数和功能都响应正常。测试通过。

## 3.性能测试

### 3.1.测试平台信息对比


|          | arm信息                          | x86信息               |
| -------- | -------------------------------- | --------------------- |
| 操作系统 | openEuler 22.03 (LTS)            | openEuler 22.03 (LTS) |
| 内核版本 | 5.10.0-60.18.0.50.oe2203.aarch64 | 5.15.79.1.oe1.x86_64  |

### 3.2.测试软件环境信息对比

|          | arm信息       | x86信息   |
| -------- | ------------- | --------- |
| gcc      | bisheng 2.1.0 | gcc 9.3.0 |
| mpi      | hmpi1.1.1     | hmpi1.1.1 |
| CMake    | 3.23.1        | 3.23.1    |
| OpenBLAS | 0.3.18        | 0.3.18    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

构建包含源图显示的 VTK 文件 4elt2.vtk 其拓扑和几何文件名为 grf/4elt2.grf 和 grf/ef_4elt2.xyz，分别使用可视化软件（如 paraview）显示。

输入文件如下（部分）

```bash
0
11143	65636
0	000
4	4941	4942	1	159
4	0	4941	2	4940
4	4939	4940	1	3
4	4	4938	4939	2
4	3	4938	5097	5
4	6	5096	5097	4
4	5095	5096	7	5
4	5095	5094	8	6
4	9	5093	5094	7
4	8	5093	10	5092
4	5092	5091	11	9
4	12	5090	5091	10
4	11	5090	13	5089
4	5089	5088	14	12
4	5087	5088	15	13
4	5086	5087	16	14
4	5085	5086	17	15
4	5084	5085	18	16
4	5083	5084	19	17
4	5082	5083	20	18
4	5081	5082	21	19
4	5080	5081	22	20
4	5079	5080	23	21
4	5078	5079	24	22
4	5077	5078	25	23
4	5076	5077	26	24
4	5075	5076	27	25
4	5074	5075	28	26
4	5073	5074	29	27
4	5072	5073	30	28
4	5071	5072	31	29
4	5070	5071	32	30
4	5069	5070	33	31
4	5068	5069	34	32
4	5067	5068	35	33
4	5066	5067	36	34
4	5065	5066	37	35
4	5064	5065	38	36
4	5063	5064	39	37
4	5062	5063	40	38
4	5061	5062	41	39
4	5060	5061	42	40
4	5059	5060	43	41
4	5058	5059	44	42
4	5057	5058	45	43
4	5056	5057	46	44
4	5055	5056	47	45
4	5054	5055	48	46
4	5053	5054	49	47
4	5052	5053	50	48
4	5051	5052	51	49
4	5050	5051	52	50
4	5049	5050	53	51
4	5048	5049	54	52
4	5047	5048	55	53
4	5046	5047	56	54
4	5045	5046	57	55
4	5044	5045	58	56
4	5043	5044	59	57
4	5042	5043	60	58
4	4976	4977	126	124
4	4975	4976	127	125
4	4974	4975	128	126
4	4973	4974	129	127
4	4972	4973	130	128
4	4971	4972	131	129
4	4970	4971	132	130
4	4969	4970	133	131
6	989	1146	830	987	1145	831
6	1146	988	832	990	831	1147
6	833	832	989	1147	991	1148
6	834	992	833	1148	990	1149
6	835	993	834	991	1150	1149
4	8199	8198	8101	8102
4	8197	8196	8292	8293
4	8291	8290	8385	8386
5	8480	8479	8383	8384	8385
5	8572	8478	8479	8573	8669
4	8763	8762	8669	8668
6	8762	6990	8858	8857	8761	8859
5	8952	8953	8954	8857	8858
5	9049	9048	8952	8953	9050
6	5133	7089	9146	9048	9049	7090
5	7089	5132	9146	9145	9144
8	5135	657	9143	7325	7324	9144	9145	9146
5	890	11140	891	1048	11138
6	890	11139	732	734	733	891
5	732	733	5210	5211	734
6	11050	9252	9253	5210	5212	5211
```

```bash
2
11143
0	  5.0944020000e+01  -1.1050810000e+01 
1	  5.1344810000e+01  -9.1294600000e+00 
2	  5.1669790000e+01  -7.1938600000e+00 
3	  5.1918480000e+01  -5.2470200000e+00 
4	  5.2090490000e+01  -3.2919300000e+00 
5	  5.2185550000e+01  -1.3316000000e+00 
6	  5.2203520000e+01   6.3095000000e-01 
7	  5.2144360000e+01   2.5926800000e+00 
8	  5.2008180000e+01   4.5505700000e+00 
9	  5.1795170000e+01   6.5016000000e+00 
10	  5.1505680000e+01   8.4427700000e+00 
11	  5.1140140000e+01   1.0371080000e+01 
12	  5.0699110000e+01   1.2283560000e+01 
13	  5.0183290000e+01   1.4177250000e+01 
14	  4.9593450000e+01   1.6049250000e+01 
15	  4.8930530000e+01   1.7896660000e+01 
16	  4.8195520000e+01   1.9716630000e+01 
17	  4.7389580000e+01   2.1506360000e+01 
18	  4.6513940000e+01   2.3263090000e+01 
19	  4.5569940000e+01   2.4984110000e+01 
20	  4.4559060000e+01   2.6666770000e+01 
21	  4.3482840000e+01   2.8308460000e+01 
22	  4.2342950000e+01   2.9906670000e+01 
23	  4.1141140000e+01   3.1458920000e+01 
24	  3.9879270000e+01   3.2962820000e+01 
25	  3.8559270000e+01   3.4416060000e+01 
26	  3.7183200000e+01   3.5816390000e+01 
27	  3.5753170000e+01   3.7161650000e+01 
28	  3.4271370000e+01   3.8449770000e+01 
29	  3.2740110000e+01   3.9678760000e+01 
30	  3.1161740000e+01   4.0846730000e+01 
31	  2.9538690000e+01   4.1951880000e+01 
32	  2.7873470000e+01   4.2992500000e+01 
33	  2.6168640000e+01   4.3966990000e+01 
34	  2.4426830000e+01   4.4873840000e+01 
35	  2.2650740000e+01   4.5711660000e+01 
36	  2.0843080000e+01   4.6479160000e+01 
37	  1.9006670000e+01   4.7175150000e+01 
38	  1.7144320000e+01   4.7798550000e+01 
39	  1.5258910000e+01   4.8348410000e+01 
40	  1.3353340000e+01   4.8823890000e+01 
41	  1.1430550000e+01   4.9224240000e+01 
42	  9.4935100000e+00   4.9548840000e+01 
43	  7.5452100000e+00   4.9797210000e+01 
44	  5.5886500000e+00   4.9968950000e+01 
45	  3.6268400000e+00   5.0063800000e+01 
46	  1.6628100000e+00   5.0081620000e+01 
47	 -3.0041000000e-01   5.0022380000e+01 
48	 -2.2598000000e+00   4.9886160000e+01 
49	 -4.2123300000e+00   4.9673180000e+01 
50	 -6.1549900000e+00   4.9383760000e+01 
51	 -8.0847800000e+00   4.9018360000e+01 
52	 -9.9987400000e+00   4.8577540000e+01 
53	 -1.1893910000e+01   4.8061970000e+01 
54	 -1.3767360000e+01   4.7472460000e+01 
55	 -1.5616220000e+01   4.6809900000e+01 
56	 -1.7437620000e+01   4.6075330000e+01 
57	 -1.9228770000e+01   4.5269870000e+01 
58	 -2.0986890000e+01   4.4394760000e+01 
59	 -2.2709280000e+01   4.3451360000e+01 
60	 -2.4393280000e+01   4.2441130000e+01 
61	 -2.6036290000e+01   4.1365610000e+01 
62	 -2.7635790000e+01   4.0226460000e+01 
63	 -2.9189300000e+01   3.9025450000e+01 
64	 -3.0694430000e+01   3.7764430000e+01 
65	 -3.2148860000e+01   3.6445330000e+01 
66	 -3.3550350000e+01   3.5070200000e+01 
67	 -3.4896730000e+01   3.3641150000e+01 
68	 -3.6185930000e+01   3.2160390000e+01 
69	 -3.7415970000e+01   3.0630200000e+01 
70	 -3.8584940000e+01   2.9052930000e+01 
71	 -3.9691040000e+01   2.7431030000e+01 
72	 -4.0732560000e+01   2.5767000000e+01 
73	 -4.1707910000e+01   2.4063390000e+01 
74	 -4.2615580000e+01   2.2322840000e+01 
75	 -4.3454160000e+01   2.0548020000e+01 
76	 -4.4222370000e+01   1.8741680000e+01 
77	 -4.4919010000e+01   1.6906610000e+01 
78	 -4.5543030000e+01   1.5045620000e+01 
79	 -4.6093440000e+01   1.3161600000e+01 
80	 -4.6569410000e+01   1.1257430000e+01 
81	 -4.6970200000e+01   9.3360800000e+00 
82	 -4.7295200000e+01   7.4004800000e+00 
83	 -4.7543900000e+01   5.4536300000e+00 
84	 -4.7715910000e+01   3.4985400000e+00 
85	 -4.7810980000e+01   1.5382100000e+00 
86	 -4.7828950000e+01  -4.2434000000e-01 
87	 -4.7769800000e+01  -2.3860700000e+00 
88	 -4.7633620000e+01  -4.3439600000e+00 
89	 -4.7420630000e+01  -6.2949900000e+00 
90	 -4.7131140000e+01  -8.2361600000e+00 
91	 -4.6765600000e+01  -1.0164470000e+01 
92	 -4.6324580000e+01  -1.2076940000e+01 
93	 -4.5808760000e+01  -1.3970640000e+01 
94	 -4.5218940000e+01  -1.5842630000e+01 
95	 -4.4556020000e+01  -1.7690040000e+01 
96	 -4.3821020000e+01  -1.9510000000e+01 
97	 -4.3015080000e+01  -2.1299730000e+01 
98	 -4.2139440000e+01  -2.3056460000e+01 
99	 -4.1195450000e+01  -2.4777470000e+01 
100	 -4.0184570000e+01  -2.6460120000e+01 
101	 -3.9108360000e+01  -2.8101810000e+01 
102	 -3.7968470000e+01  -2.9700010000e+01 
103	 -3.6766660000e+01  -3.1252250000e+01 
104	 -3.5504790000e+01  -3.2756150000e+01 
105	 -3.4184800000e+01  -3.4209380000e+01 
106	 -3.2808730000e+01  -3.5609700000e+01 
107	 -3.1378690000e+01  -3.6954960000e+01 
108	 -2.9896900000e+01  -3.8243070000e+01 
109	 -2.8365640000e+01  -3.9472060000e+01 
110	 -2.6787270000e+01  -4.0640020000e+01 
111	 -2.5164220000e+01  -4.1745160000e+01 
112	 -2.3498990000e+01  -4.2785780000e+01 
113	 -2.1794160000e+01  -4.3760260000e+01 
114	 -2.0052350000e+01  -4.4667100000e+01 
115	 -1.8276250000e+01  -4.5504920000e+01 
116	 -1.6468600000e+01  -4.6272410000e+01 
117	 -1.4632170000e+01  -4.6968390000e+01 
118	 -1.2769820000e+01  -4.7591790000e+01 
119	 -1.0884400000e+01  -4.8141650000e+01 
120	 -8.9788300000e+00  -4.8617120000e+01 
121	 -7.0560400000e+00  -4.9017460000e+01 
122	 -5.1189900000e+00  -4.9342070000e+01 
123	 -3.1706800000e+00  -4.9590430000e+01 
124	 -1.2141100000e+00  -4.9762170000e+01 
125	  7.4771000000e-01  -4.9857020000e+01 
126	  2.7117400000e+00  -4.9874840000e+01 
127	  4.6749700000e+00  -4.9815590000e+01 
128	  6.6343600000e+00  -4.9679370000e+01 
129	  8.5868900000e+00  -4.9466390000e+01 
130	  1.0529560000e+01  -4.9176980000e+01 
131	  1.2459360000e+01  -4.8811580000e+01 
132	  1.4373330000e+01  -4.8370760000e+01 
133	  1.6268500000e+01  -4.7855200000e+01 
134	  1.8141970000e+01  -4.7265680000e+01 
135	  1.9990830000e+01  -4.6603130000e+01 
136	  2.1812240000e+01  -4.5868560000e+01 
137	  2.3603380000e+01  -4.5063110000e+01 
138	  2.5361510000e+01  -4.4188010000e+01 
139	  2.7083900000e+01  -4.3244610000e+01 
140	  2.8767910000e+01  -4.2234380000e+01 
141	  3.0410930000e+01  -4.1158870000e+01 
142	  3.2010430000e+01  -4.0019730000e+01 
143	  3.3563940000e+01  -3.8818730000e+01 
144	  3.5069080000e+01  -3.7557710000e+01 
145	  3.6523510000e+01  -3.6238620000e+01 
146	  3.7925000000e+01  -3.4863490000e+01 
147	  3.9271380000e+01  -3.3434450000e+01 
148	  4.0560580000e+01  -3.1953700000e+01 
149	  4.1790610000e+01  -3.0423510000e+01 
150	  4.2959580000e+01  -2.8846260000e+01 
151	  4.4065680000e+01  -2.7224360000e+01 
152	  4.5107200000e+01  -2.5560330000e+01 
153	  4.6082550000e+01  -2.3856730000e+01 
154	  4.6990210000e+01  -2.2116180000e+01 
155	  4.7828790000e+01  -2.0341370000e+01 
156	  4.8596990000e+01  -1.8535040000e+01 
157	  4.9293640000e+01  -1.6699970000e+01 
158	  4.9917640000e+01  -1.4838990000e+01 
159	  5.0468060000e+01  -1.2954970000e+01 
160	  4.1519100000e+00   8.0790000000e-02 
161	  4.1502300000e+00   8.1030000000e-02 
162	  4.1452700000e+00   8.1720000000e-02 
163	  4.1370500000e+00   8.2860000000e-02 
164	  4.1255900000e+00   8.4420000000e-02 
165	  4.1108900000e+00   8.6380000000e-02 
166	  4.0929300000e+00   8.8710000000e-02 
167	  4.0717200000e+00   9.1370000000e-02 
168	  4.0472700000e+00   9.4350000000e-02 
169	  4.0195900000e+00   9.7640000000e-02 
471	  4.1606600000e+00  -7.1200000000e-02 
472	  4.1664500000e+00  -6.6300000000e-02 
473	  4.1732200000e+00  -6.1800000000e-02 
474	  4.1809200000e+00  -5.7750000000e-02 
475	  4.1894700000e+00  -5.4180000000e-02 
476	  4.1988200000e+00  -5.1180000000e-02 
785	  3.9211100000e+00   3.8121000000e-01 
786	  3.9715200000e+00   3.6955000000e-01 
787	  4.0043100000e+00   3.5411000000e-01 
788	  4.0357600000e+00   3.2936000000e-01 
789	  4.0631000000e+00   3.0915000000e-01 
790	  4.0818300000e+00   2.8809000000e-01 
791	  4.1221100000e+00   2.5714000000e-01 
1732	  4.3250000000e+00   8.7242000000e-01 
1733	  4.3736400000e+00   8.0799000000e-01 
1734	  4.4304000000e+00   7.7258000000e-01 
1735	  4.4309900000e+00   7.0478000000e-01 
1736	  4.4999000000e+00   6.6357000000e-01 
1737	  4.5236700000e+00   5.9685000000e-01 
1738	  4.5572500000e+00   5.3539000000e-01 
1739	  4.5761300000e+00   4.8337000000e-01 
1740	  4.5940100000e+00   4.1287000000e-01 
1741	  4.6169900000e+00   3.8648000000e-01 
1742	  4.6286600000e+00   3.1347000000e-01 
1743	  4.6436200000e+00   2.4857000000e-01 
1744	  4.6475800000e+00   1.9522000000e-01 
1745	  4.6528300000e+00   1.3662000000e-01 
1746	  4.6553600000e+00   8.6390000000e-02 
1747	  4.7652600000e+00  -3.1640000000e-02 
1748	  4.7573300000e+00  -9.3900000000e-02 
1749	  4.7442100000e+00  -1.5749000000e-01 
1750	  4.7246300000e+00  -2.2528000000e-01 
1751	  4.6787100000e+00  -3.4915000000e-01 
1752	  4.6493600000e+00  -4.1656000000e-01 
1753	  4.6110500000e+00  -4.7667000000e-01 
1754	  4.5712200000e+00  -5.3987000000e-01 
1755	  4.5347500000e+00  -5.9657000000e-01 
1756	  4.4984900000e+00  -6.5308000000e-01 
1757	  4.4350200000e+00  -7.2251000000e-01 
3289	  5.6732000000e-01   5.3531900000e+00 
3290	  7.8808000000e-01   5.4078600000e+00 
3291	  1.0107900000e+00   5.4544700000e+00 
3292	  1.2351000000e+00   5.4929400000e+00 
3293	  1.4607000000e+00   5.5232100000e+00 
5480	  4.9864000000e+00  -7.6023000000e-01 
5481	  4.9615700000e+00  -7.3117000000e-01 
5482	  4.9367800000e+00  -7.0218000000e-01 
5483	  4.9123000000e+00  -6.7598000000e-01 
5484	  4.8928000000e+00  -6.4618000000e-01 
5485	  4.8643600000e+00  -6.1678000000e-01 
5486	  4.8463500000e+00  -5.9254000000e-01 
5487	  4.8137800000e+00  -5.6252000000e-01 
5488	  4.7943800000e+00  -5.3862000000e-01 
5489	  4.7711900000e+00  -5.1069000000e-01 
8037	  4.6474300000e+00  -9.5550000000e-02 
8038	  4.6554800000e+00  -1.0303000000e-01 
8039	  4.6606200000e+00  -1.1245000000e-01 
8040	  4.6652200000e+00  -1.2183000000e-01 
8041	  4.6697100000e+00  -1.3057000000e-01 
8042	  4.6743600000e+00  -1.3879000000e-01 
8043	  4.6783700000e+00  -1.4737000000e-01 
8044	  4.6783000000e+00  -1.5605000000e-01 
8045	  4.6780300000e+00  -1.6401000000e-01 
8046	  4.6774900000e+00  -1.7185000000e-01 
8047	  4.6764700000e+00  -1.8040000000e-01 
8048	  4.6847000000e+00  -1.8662000000e-01 
8049	  4.6812800000e+00  -1.9481000000e-01 
8050	  4.6770100000e+00  -2.0305000000e-01 
11142	  5.9354000000e-01   3.8493000000e-01 
```

### 3.5.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 实际CPU时间 | 0.231s | 0.280s |
| 用户时间    | 0.093s | 0.068s |

### 3.6.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 线程数      | 4      | 4      |
| 实际CPU时间 | 0.180s | 0.266s |
| 用户时间    | 0.184s | 0.194s |

arm多线程时间耗费数据表：

| 线程          | 1     | 2     | 4     | 8     |
| :------------ | ----- | ----- | ----- | ----- |
| 用户时间(s)   | 0.231 | 0.176 | 0.180 | 0.299 |
| 用户态时间(s) | 0.093 | 0.103 | 0.184 | 0.359 |
| 内核态时间(s) | 0.260 | 0.298 | 0.417 | 1.348 |

x86多线程时间耗费数据表：

| 线程            | 1     | 2     | 3     | 4     |
| --------------- | ----- | ----- | ----- | ----- |
| 用户时间 （s）  | 0.280 | 0.210 | 0.229 | 0.266 |
| 用户态时间（s） | 0.068 | 0.079 | 0.174 | 0.194 |
| 内核态时间（s） | 0.324 | 0.290 | 0.368 | 0.613 |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.7.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

图形分区，它使用分区策略使用顶点，将源图拆分为规定数量的部分边缘分隔符实现的映射方法主要来自图论。

测试文件（部分）如下

```bash
0
9800	57978
0	000
3	413	407	6
4	9771	43	9772	44
4	76	1474	1475	77
3	1242	147	148
3	693	206	207
3	521	348	349
4	7	412	413	0
4	6	412	8	647
4	9	3238	647	7
4	3235	3238	8	10
4	11	3233	3235	9
4	3234	3233	10	12
4	3684	3234	11	13
4	14	418	3684	12
4	15	417	418	13
4	14	417	16	3088
4	17	3086	3088	15
6	5543	5545	5700	5540	5541	5542
6	6177	6178	9797	9798	6181	9799
6	6782	6177	9796	9798	6776	6780
7	9797	9796	6776	9799	9724	9722	6775
6	9796	6181	6183	6645	9724	9798
```

### 4.2 数据分析

Output:
----------------------------------------------------------
T	Mapping	min=0.00908184	max=0.0129266	avg=0.0110013
T	I/O	min=0.0105579	max=0.0148993	avg=0.0130691
T	Total	min=0.0234845	max=0.0252681	avg=0.0240704
M	Processors 3/3(1)
M	Target min=3172	max=3368	avg=3266.67	dlt=0.0206803	maxavg=1.03102
M	Neighbors min=1	max=2	sum=4
M	CommDilat=0.008865	(257)
M	CommExpan=0.008865	(257)
M	CommCutSz=0.008865	(257)
M	CommDelta=1.000000
M	CommLoad[0]=0.991135
M	CommLoad[1]=0.008865

Test Passed.
"dfull_2" end time: Dec 14 22:09 CST
"dfull_2" time elapsed: 00:00:00

### 4.3 分析结果

从arm输出结果可以看出测试通过。