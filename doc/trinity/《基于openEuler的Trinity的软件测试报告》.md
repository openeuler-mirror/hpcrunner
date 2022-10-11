# 《基于openEuler的Trinity软件测试报告》

## 1.规范性自检

项目使用了Perltidy对文件进行格式化

Perltidy 是一种用于缩进和重新格式化用 Perl 编写的脚本的工具。

编写脚本遍历所有的perl文件，文件内容如下

```bash
#!/bin/bash

readDir() {
  local dir=$1
  local files
  files=$(ls "$dir")
  for file in $files; do
    local path="$dir/$file" 
    if [ -d "$path" ]; then
      perltidy -b "$path/*.pl"
      perltidy -b "$path/*.pm"
      readDir "$path"
    else
        if [ "${file##*.}"x = "pl"x ]||[ "${file##*.}"x = "pm"x ];then
            # 格式化代码
            perltidy -b "$path"
            rm -f "$path.bak"
        fi
      echo "$path"
    fi
  done
}

readDir .
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


在trinity项目根目录下运行,运行结果如下

```bash
[root@ecs-7567 trinityrnaseq]# python run.py 
/root/trinityrnaseq
当前文件夹下共有【】的文件49个
当前文件夹下共有【.pl】的文件343个
当前文件夹下共有【.notes】的文件2个
当前文件夹下共有【.in】的文件3个
当前文件夹下共有【.ph】的文件1个
当前文件夹下共有【.adj】的文件8个
当前文件夹下共有【.gff】的文件1个
当前文件夹下共有【.md】的文件6个
当前文件夹下共有【.py】的文件31个
当前文件夹下共有【.cpp】的文件8个
当前文件夹下共有【.idx】的文件1个
当前文件夹下共有【.ac】的文件1个
当前文件夹下共有【.bam】的文件1个
当前文件夹下共有【.fa】的文件8个
当前文件夹下共有【.sample】的文件11个
当前文件夹下共有【.status】的文件1个
当前文件夹下共有【.p5b】的文件1个
当前文件夹下共有【.log】的文件1个
当前文件夹下共有【.fq】的文件20个
当前文件夹下共有【.bed】的文件1个
当前文件夹下共有【.0】的文件1个
当前文件夹下共有【.cgi】的文件1个
当前文件夹下共有【.p2】的文件1个
当前文件夹下共有【.sh】的文件65个
当前文件夹下共有【.m4】的文件1个
当前文件夹下共有【.pack】的文件1个
当前文件夹下共有【.hpp】的文件1个
当前文件夹下共有【.fasta】的文件1个
当前文件夹下共有【.refSeq】的文件9个
当前文件夹下共有【.pm】的文件63个
当前文件夹下共有【.sam】的文件8个
当前文件夹下共有【.Po】的文件2个
当前文件夹下共有【.wdl】的文件4个
当前文件夹下共有【.R】的文件17个
当前文件夹下共有【.p1】的文件1个
当前文件夹下共有【.template】的文件1个
当前文件夹下共有【.p3】的文件1个
当前文件夹下共有【.dot】的文件1个
当前文件夹下共有【.h】的文件6个
当前文件夹下共有【.Rscript】的文件9个
当前文件夹下共有【.gene_trans_map】的文件1个
当前文件夹下共有【.png】的文件9个
当前文件夹下共有【.header】的文件1个
当前文件夹下共有【.cont】的文件1个
当前文件夹下共有【.p4a】的文件1个
当前文件夹下共有【.am】的文件2个
当前文件夹下共有【.p4b】的文件1个
当前文件夹下共有【.yml】的文件1个
当前文件夹下共有【.jar】的文件4个
当前文件夹下共有【.txt】的文件12个
当前文件夹下共有【.html】的文件2个
当前文件夹下共有【.matrix】的文件1个
当前文件夹下共有【.pdf】的文件1个
当前文件夹下共有【.gz】的文件10个
```

查看上述结果可知主要源码文件后缀名为 `pl`,`pm`.

## 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.pl\|.*\.pm" | xargs wc -l
```

统计结果

```bash
 74896 total
```

## 1.3.统计不符合要求的总行数

```
[root@ecs-7567 trinityrnaseq]# git commit -m "fomat update"
[master 1c77f70] fomat update
 405 files changed, 42849 insertions(+), 41820 deletions(-)
 rewrite Analysis/DifferentialExpression/TissueEnrichment/pairwise_DE_summary_to_DE_classification.pl (62%)
 rewrite Analysis/DifferentialExpression/deprecated/prep_n_run_GOplot.pl (61%)
 rewrite Analysis/DifferentialExpression/pairwise_summaries/add_counts_to_classes.pl (69%)
 rewrite Analysis/DifferentialExpression/pairwise_summaries/examine_rank_correlation.pl (68%)
 rewrite Analysis/DifferentialExpression/pairwise_summaries/pairwise_DE_summary_to_DE_classification.pl (63%)
 rewrite Analysis/DifferentialExpression/summarize_diff_expr_across_min_threshold_ranges.pl (61%)
 rewrite Analysis/FL_reconstruction_analysis/fusion_comparisons_via_maps_files.pl (60%)
 rewrite Analysis/FL_reconstruction_analysis/maps_file_to_paralog_representation.pl (85%)
 rewrite Analysis/FL_reconstruction_analysis/util/blat_full_length_mappings.pl (69%)
 rewrite Analysis/FL_reconstruction_analysis/util/blat_map_filter_with_isoforms.pl (73%)
 rewrite Analysis/FL_reconstruction_analysis/util/blat_psl_to_align_summary_stats.pl (73%)
 rewrite Analysis/FL_reconstruction_analysis/util/blat_top_tier_genes.pl (86%)
 rewrite Analysis/SuperTranscripts/AllelicVariants/VCF_to_annotated_SNP_report.pl (76%)
 rewrite PerlLib/Ascii_genome_illustrator.pm (93%)
 rewrite PerlLib/BED_utils.pm (88%)
 rewrite PerlLib/CDNA/Genome_based_cDNA_assembler.pm (60%)
 rewrite PerlLib/CDNA/Genome_based_cDNA_graph_assembler.pm (61%)
 rewrite PerlLib/CDNA/Overlap_assembler.pm (72%)
 rewrite PerlLib/CIGAR.pm (92%)
 rewrite PerlLib/ColorGradient.pm (89%)
 rewrite PerlLib/EM.pm (86%)
 rewrite PerlLib/Fasta_reader.pm (61%)
 rewrite PerlLib/Fastq_reader.pm (61%)
 rewrite PerlLib/GFF3_alignment_utils.pm (75%)
 rewrite PerlLib/GTF.pm (82%)
 rewrite PerlLib/KmerGraphLib/GenericGraph.pm (89%)
 rewrite PerlLib/KmerGraphLib/GenericNode.pm (79%)
 rewrite PerlLib/KmerGraphLib/KmerGraph.pm (93%)
 rewrite PerlLib/KmerGraphLib/KmerNode.pm (88%)
 rewrite PerlLib/KmerGraphLib/ReadCoverageGraph.pm (92%)
 rewrite PerlLib/KmerGraphLib/ReadCoverageNode.pm (80%)
 rewrite PerlLib/KmerGraphLib/ReadTracker.pm (78%)
 rewrite PerlLib/KmerGraphLib/SAM_entry.pm (67%)
 rewrite PerlLib/KmerGraphLib/SAM_reader.pm (80%)
 rewrite PerlLib/KmerGraphLib/SAM_to_AlignGraph.pm (81%)
 rewrite PerlLib/KmerGraphLib/StringGraph.pm (91%)
 rewrite PerlLib/KmerGraphLib/StringNode.pm (88%)
 rewrite PerlLib/Longest_orf.pm (73%)
 rewrite PerlLib/Overlap_info.pm (86%)
 rewrite PerlLib/PSL_parser.pm (75%)
 rewrite PerlLib/SAM_entry.pm (63%)
 rewrite PerlLib/SAM_reader.pm (84%)
 rewrite PerlLib/WigParser.pm (61%)
 rewrite util/PBS/N50stats.pl (85%)
 rewrite util/PBS/trinity_kill.pl (86%)
 rewrite util/misc/SAM_intron_extractor.pl (74%)
 rewrite util/misc/SAM_pair_to_bed.pl (83%)
 rewrite util/misc/SAM_show_alignment.pl (65%)
 rewrite util/misc/SAM_to_bed.pl (83%)
 rewrite util/misc/Trinity_genome_aligned_gff3_to_regrouped_genes_gtf.pl (61%)
 rewrite util/misc/alexie_analyze_blast.pl (83%)
 rewrite util/misc/align_reads_launch_igv.pl (65%)
 rewrite util/misc/altsplice_simulation_toolkit/sim_single_bubble.pl (60%)
 rewrite util/misc/bam_gene_tests/extract_bam_reads_per_target_gene.pl (68%)
 rewrite util/misc/bam_gene_tests/extract_bam_reads_per_target_transcript.pl (68%)
 rewrite util/misc/blast_outfmt6_group_segments.tophit_coverage.pl (67%)
 rewrite util/misc/blat_util/blat_sam_add_reads2.pl (81%)
 rewrite util/misc/blat_util/blat_to_sam.pl (68%)
 rewrite util/misc/blat_util/run_BLAT_shortReads.pl (73%)
 rewrite util/misc/blat_util/top_blat_sam_extractor.pl (78%)
 rewrite util/misc/cdna_fasta_file_to_transcript_gtf.pl (63%)
 rewrite util/misc/decode_SAM_flag_value.pl (88%)
 rewrite util/misc/describe_SAM_read_flag_info.pl (89%)
 rewrite util/misc/fastQ_rand_subset.reservoir_sampling_reqiures_high_mem.pl (67%)
 rewrite util/misc/fastQ_top_N_records.pl (70%)
 rewrite util/misc/fastq_cleaner.pl (82%)
 rewrite util/misc/fastq_stats.pl (67%)
 rewrite util/misc/get_longest_isoform_seq_per_trinity_gene.pl (62%)
 rewrite util/misc/gff3_file_to_cdna.pl (66%)
 rewrite util/misc/gff3_file_utr_coverage_trimmer.pl (60%)
 rewrite util/misc/gmap_gff3_to_percent_length_stats.count_mapped_transcripts.pl (62%)
 rewrite util/misc/gtf_to_bed_format.pl (87%)
 rewrite util/misc/gtf_to_introns.pl (77%)
 rewrite util/misc/join_any.pl (74%)
 rewrite util/misc/m8_blastclust.pl (82%)
 rewrite util/misc/nameSorted_SAM_to_paired_fastq.pl (61%)
 rewrite util/misc/pair_up_fastq_files_R1_R2.pl (63%)
 rewrite util/misc/run_HiCpipe_bowtie.pl (62%)
 rewrite util/misc/run_STAR_via_samples_file.pl (60%)
 rewrite util/misc/seqinfo_refseq_to_dot.pl (62%)
 rewrite util/misc/splice_path_analysis/assess_intron_path_sensitivity.pl (91%)
 rewrite util/misc/splice_path_analysis/intron_barcharter.pl (70%)
 rewrite util/misc/transcript_fasta_to_ORF_pics.pl (66%)
 rewrite util/misc/transcript_gff3_to_bed.pl (87%)
 rewrite util/support_scripts/SAM_coordSorted_fragment_Read_coverage_writer.pl (84%)
 rewrite util/support_scripts/SAM_coordSorted_fragment_coverage_writer2.pl (89%)
 rewrite util/support_scripts/SAM_set_transcribed_orient_info.pl (87%)
 rewrite util/support_scripts/SAM_strand_separator.pl (64%)
 rewrite util/support_scripts/annotate_chrysalis_welds_with_iworm_names.pl (82%)
 rewrite util/support_scripts/define_SAM_coverage_partitions2.pl (77%)
 rewrite util/support_scripts/define_coverage_partitions.pl (72%)
 rewrite util/support_scripts/ensure_coord_sorted_sam.pl (62%)
 rewrite util/support_scripts/extract_reads_per_partition.pl (72%)
 rewrite util/support_scripts/fastQ_to_tab.pl (64%)
 rewrite util/support_scripts/fragment_coverage_writer.pl (73%)
 rewrite util/support_scripts/inchworm_transcript_splitter.pl (69%)
 rewrite util/support_scripts/jaccard_fasta_clipper.pl (75%)
 rewrite util/support_scripts/join_partitions_within_range.pl (71%)
 rewrite util/support_scripts/revcomp_fasta.pl (85%)
 rewrite util/support_scripts/segment_GFF_partitions.pl (90%)
```

## 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 99.5%          1-405/74896*100%

不通过率  : 0.5%           405/74896*100%

## 2.功能性测试

### 2.1.所选测试案例

trinity在Makefile中内置两条测试命令，分别是test_trinity和test_all，这里选取test_trinity。

test_trinity的测试命令如下：
```bash
#!/bin/bash -ve

#######################################################
##  Run Trinity to Generate Transcriptome Assemblies ##
#######################################################

if [ -z ${TRINITY_HOME} ]; then
    echo "Must set env var TRINITY_HOME"
    exit 1
fi


${TRINITY_HOME}/Trinity --seqType fq --max_memory 2G \
              --left reads.left.fq.gz \
              --right reads.right.fq.gz \
              --SS_lib_type RF \
              --CPU 1 

##### Done Running Trinity #####

if [ $* ]; then
    # check full-length reconstruction stats:

    ${TRINITY_HOME}/util/misc/illustrate_ref_comparison.pl __indiv_ex_sample_derived/refSeqs.fa trinity_out_dir.Trinity.fasta 90

    ./test_FL.sh --query  trinity_out_dir.Trinity.fasta --target __indiv_ex_sample_derived/refSeqs.fa --no_reuse

fi
```

在项目根目录下执行命令来进行测试
```bash
make test_trinity
```

### 2.2.运行结果
```bash
[root@host trinityrnaseq-v2.14.0]# make test_trinity
cd sample_data/test_Trinity_Assembly && make test
make[1]: 进入目录“/root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly”
./runMe.sh
module () {  eval `/usr/bin/modulecmd bash $*`
}
#!/bin/bash -ve

#######################################################
##  Run Trinity to Generate Transcriptome Assemblies ##
#######################################################

if [ -z ${TRINITY_HOME} ]; then
    echo "Must set env var TRINITY_HOME"
    exit 1
fi


${TRINITY_HOME}/Trinity --seqType fq --max_memory 2G \
              --left reads.left.fq.gz \
              --right reads.right.fq.gz \
              --SS_lib_type RF \
              --CPU 1 


     ______  ____   ____  ____   ____  ______  __ __
    |      ||    \ |    ||    \ |    ||      ||  |  |
    |      ||  D  ) |  | |  _  | |  | |      ||  |  |
    |_|  |_||    /  |  | |  |  | |  | |_|  |_||  ~  |
      |  |  |    \  |  | |  |  | |  |   |  |  |___, |
      |  |  |  .  \ |  | |  |  | |  |   |  |  |     |
      |__|  |__|\_||____||__|__||____|  |__|  |____/

    Trinity-v2.14.0



Left read files: $VAR1 = [
          'reads.left.fq.gz'
        ];
Right read files: $VAR1 = [
          'reads.right.fq.gz'
        ];
Trinity version: Trinity-v2.14.0
-currently using the latest production release of Trinity.

Monday, October 10, 2022: 22:20:21	CMD: java -Xmx64m -XX:ParallelGCThreads=2  -jar /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/ExitTester.jar 0
Monday, October 10, 2022: 22:20:22	CMD: java -Xmx4g -XX:ParallelGCThreads=2  -jar /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/ExitTester.jar 1
Monday, October 10, 2022: 22:20:22	CMD: mkdir -p /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir
Monday, October 10, 2022: 22:20:22	CMD: mkdir -p /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis


----------------------------------------------------------------------------------
-------------- Trinity Phase 1: Clustering of RNA-Seq Reads  ---------------------
----------------------------------------------------------------------------------

---------------------------------------------------------------
------------ In silico Read Normalization ---------------------
-- (Removing Excess Reads Beyond 200 Coverage --
---------------------------------------------------------------

# running normalization on reads: $VAR1 = [
          [
            '/root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.left.fq.gz'
          ],
          [
            '/root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.right.fq.gz'
          ]
        ];


Monday, October 10, 2022: 22:20:22	CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/insilico_read_normalization.pl --seqType fq --JM 2G  --max_cov 200 --min_cov 1 --CPU 1 --output /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization --max_CV 10000  --SS_lib_type RF  --left /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.left.fq.gz --right /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.right.fq.gz --pairs_together  --PARALLEL_STATS  
-prepping seqs
Converting input files. (both directions in parallel)CMD: seqtk-trinity seq -r -A -R 1  <(gunzip -c /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.left.fq.gz) >> left.fa
CMD: seqtk-trinity seq -A -R 2  <(gunzip -c /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.right.fq.gz) >> right.fa
CMD finished (0 seconds)
CMD finished (0 seconds)
CMD: touch left.fa.ok
CMD finished (0 seconds)
CMD: touch right.fa.ok
CMD finished (0 seconds)
Done converting input files.CMD: cat left.fa right.fa > both.fa
CMD finished (0 seconds)
CMD: touch both.fa.ok
CMD finished (0 seconds)
-kmer counting.
-------------------------------------------
----------- Jellyfish  --------------------
-- (building a k-mer catalog from reads) --
-------------------------------------------

CMD: jellyfish count -t 1 -m 25 -s 100000000  both.fa
CMD finished (1 seconds)
CMD: jellyfish histo -t 1 -o jellyfish.K25.min2.kmers.fa.histo mer_counts.jf
CMD finished (0 seconds)
CMD: jellyfish dump -L 2 mer_counts.jf > jellyfish.K25.min2.kmers.fa
CMD finished (0 seconds)
CMD: touch jellyfish.K25.min2.kmers.fa.success
CMD finished (0 seconds)
-generating stats files
CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/..//Inchworm/bin/fastaToKmerCoverageStats --reads left.fa --kmers jellyfish.K25.min2.kmers.fa --kmer_size 25  --num_threads 1  > left.fa.K25.stats
CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/..//Inchworm/bin/fastaToKmerCoverageStats --reads right.fa --kmers jellyfish.K25.min2.kmers.fa --kmer_size 25  --num_threads 1  > right.fa.K25.stats
-reading Kmer occurrences...
-reading Kmer occurrences...

 done parsing 100973 Kmers, 100873 added, taking 0 seconds.

 done parsing 100973 Kmers, 100873 added, taking 0 seconds.
STATS_GENERATION_TIME: 1 seconds.
STATS_GENERATION_TIME: 1 seconds.
CMD finished (1 seconds)
CMD finished (1 seconds)
CMD: touch left.fa.K25.stats.ok
CMD finished (0 seconds)
CMD: touch right.fa.K25.stats.ok
CMD finished (0 seconds)
-sorting each stats file by read name.
CMD: head -n1 left.fa.K25.stats > left.fa.K25.stats.sort && tail -n +2 left.fa.K25.stats | /usr/bin/sort --parallel=1 -k1,1 -T . -S 1G >> left.fa.K25.stats.sort
CMD: head -n1 right.fa.K25.stats > right.fa.K25.stats.sort && tail -n +2 right.fa.K25.stats | /usr/bin/sort --parallel=1 -k1,1 -T . -S 1G >> right.fa.K25.stats.sort
CMD finished (0 seconds)
CMD finished (0 seconds)
CMD: touch left.fa.K25.stats.sort.ok
CMD finished (0 seconds)
CMD: touch right.fa.K25.stats.sort.ok
CMD finished (0 seconds)
-defining normalized reads
CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/..//util/support_scripts//nbkc_merge_left_right_stats.pl --left left.fa.K25.stats.sort --right right.fa.K25.stats.sort --sorted > pairs.K25.stats
-opening left.fa.K25.stats.sort
-opening right.fa.K25.stats.sort
-done opening files.
CMD finished (0 seconds)
CMD: touch pairs.K25.stats.ok
CMD finished (0 seconds)
CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/..//util/support_scripts//nbkc_normalize.pl --stats_file pairs.K25.stats --max_cov 200  --min_cov 1 --max_CV 10000 > pairs.K25.stats.C200.maxCV10000.accs
30472 / 30575 = 99.66% reads selected during normalization.
0 / 30575 = 0.00% reads discarded as likely aberrant based on coverage profiles.
0 / 30575 = 0.00% reads discarded as below minimum coverage threshold=1
CMD finished (1 seconds)
CMD: touch pairs.K25.stats.C200.maxCV10000.accs.ok
CMD finished (0 seconds)
-search and capture.
-preparing to extract selected reads from: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.left.fq.gz ... done prepping, now search and capture.
-capturing normalized reads from: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.left.fq.gz
-preparing to extract selected reads from: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.right.fq.gz ... done prepping, now search and capture.
-capturing normalized reads from: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/reads.right.fq.gz
CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.left.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq.ok
CMD finished (0 seconds)
CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.right.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq.ok
CMD finished (0 seconds)
CMD: ln -sf /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.left.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq left.norm.fq
CMD finished (0 seconds)
CMD: ln -sf /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.right.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq right.norm.fq
CMD finished (0 seconds)
-removing tmp dir /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/tmp_normalized_reads


Normalization complete. See outputs: 
	/root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.left.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq
	/root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/reads.right.fq.gz.normalized_K25_maxC200_minC1_maxCV10000.fq
Monday, October 10, 2022: 22:20:25	CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/normalization.ok
Converting input files. (in parallel)Monday, October 10, 2022: 22:20:25	CMD: cat /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/left.norm.fq | seqtk-trinity seq -r -A -R 1 - >> left.fa
Monday, October 10, 2022: 22:20:25	CMD: cat /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/insilico_read_normalization/right.norm.fq | seqtk-trinity seq -A -R 2 - >> right.fa
Monday, October 10, 2022: 22:20:25	CMD: touch left.fa.ok
Monday, October 10, 2022: 22:20:25	CMD: touch right.fa.ok
Monday, October 10, 2022: 22:20:25	CMD: touch left.fa.ok right.fa.ok
Monday, October 10, 2022: 22:20:25	CMD: cat left.fa right.fa > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa
Monday, October 10, 2022: 22:20:25	CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa.ok
-------------------------------------------
----------- Jellyfish  --------------------
-- (building a k-mer (25) catalog from reads) --
-------------------------------------------

* [Mon Oct 10 22:20:25 2022] Running CMD: jellyfish count -t 1 -m 25 -s 100000000 -o mer_counts.25.asm.jf /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa
* [Mon Oct 10 22:20:26 2022] Running CMD: jellyfish dump -L 1 mer_counts.25.asm.jf > jellyfish.kmers.25.asm.fa
* [Mon Oct 10 22:20:26 2022] Running CMD: jellyfish histo -t 1 -o jellyfish.kmers.25.asm.fa.histo mer_counts.25.asm.jf
----------------------------------------------
--------------- Inchworm (K=25, asm) ---------------------
-- (Linear contig construction from k-mers) --
----------------------------------------------

* [Mon Oct 10 22:20:26 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/Inchworm/bin//inchworm --kmers jellyfish.kmers.25.asm.fa --run_inchworm -K 25 --monitor 1   --num_threads 1  --PARALLEL_IWORM   --min_any_entropy 1.0   -L 25  --no_prune_error_kmers  > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/inchworm.fa.tmp
Kmer length set to: 25
Min assembly length set to: 25
Monitor turned on, set to: 1
min entropy set to: 1
setting number of threads to: 1
-setting parallel iworm mode.
-reading Kmer occurrences...

 [0M] Kmers parsed.     
 [0M] Kmers parsed.     
 [0M] Kmers parsed.     
 [0M] Kmers parsed.     
 [0M] Kmers parsed.     
 done parsing 519541 Kmers, 519541 added, taking 1 seconds.

TIMING KMER_DB_BUILDING 1 s.
Pruning kmers (min_kmer_count=1 min_any_entropy=1 min_ratio_non_error=0.005)
Pruned 4252 kmers from catalog.
	Pruning time: 0 seconds = 0 minutes.

TIMING PRUNING 0 s.
-populating the kmer seed candidate list.
Kcounter hash size: 519541
Processed 515289 non-zero abundance kmers in kcounter.
-Not sorting list of kmers, given parallel mode in effect.
-beginning inchworm contig assembly.
Total kcounter hash size: 519541 vs. sorted list size: 515289
num threads set to: 1
Done opening file. tmp.iworm.fa.pid_29706.thread_0

	Iworm contig assembly time: 1 seconds = 0.0166667 minutes.

TIMING CONTIG_BUILDING 1 s.

TIMING PROG_RUNTIME 2 s.
* [Mon Oct 10 22:20:28 2022] Running CMD: mv /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/inchworm.fa.tmp /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/inchworm.fa
Monday, October 10, 2022: 22:20:28	CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/inchworm.fa.finished
--------------------------------------------------------
-------------------- Chrysalis -------------------------
-- (Contig Clustering & de Bruijn Graph Construction) --
--------------------------------------------------------

inchworm_target: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa
bowtie_reads_fa: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa
chrysalis_reads_fa: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa
* [Mon Oct 10 22:20:28 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/filter_iworm_by_min_length_or_cov.pl /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/inchworm.fa 100 10 > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100
* [Mon Oct 10 22:20:28 2022] Running CMD: /root/hpcrunner/software/libs/gcc9/bowtie2/2.4.5/bin/bowtie2-build --threads 1 -o 3 /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 1>/dev/null
* [Mon Oct 10 22:20:28 2022] Running CMD: bash -c " set -o pipefail;/root/hpcrunner/software/libs/gcc9/bowtie2/2.4.5/bin/bowtie2 --local -k 2 --no-unal --threads 1 -f --score-min G,20,8 -x /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa  | samtools view -@ 1 -F4 -Sb - | samtools sort -m 1073741824 -@ 1 -no /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm.bowtie.nameSorted.bam" 
* [Mon Oct 10 22:20:31 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/scaffold_iworm_contigs.pl /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm.bowtie.nameSorted.bam /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_scaffolds.txt
* [Mon Oct 10 22:20:32 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/Chrysalis/bin/GraphFromFasta -i /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 -r /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa -min_contig_length 200 -min_glue 2 -glue_factor 0.05 -min_iso_ratio 0.05 -t 1 -k 24 -kk 48  -strand  -scaffolding /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_scaffolds.txt  > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt
* [Mon Oct 10 22:20:32 2022] Running CMD: /usr/bin/sort --parallel=1 -T . -S 2G  -k9,9gr /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt.sorted
* [Mon Oct 10 22:20:32 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/annotate_chrysalis_welds_with_iworm_names.pl /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100 /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt.sorted > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt.sorted.wIwormNames
* [Mon Oct 10 22:20:32 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/Chrysalis/bin/BubbleUpClustering -i /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/inchworm.fa.min100  -weld_graph /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/iworm_cluster_welds_graph.txt.sorted -min_contig_length 200 -max_cluster_size 25  > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/GraphFromIwormFasta.out
* [Mon Oct 10 22:20:32 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/Chrysalis/bin/CreateIwormFastaBundle -i /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/GraphFromIwormFasta.out -o /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/bundled_iworm_contigs.fasta -min 200
* [Mon Oct 10 22:20:32 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/Chrysalis/bin/ReadsToTranscripts -i /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa -f /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/bundled_iworm_contigs.fasta -o /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/readsToComponents.out -t 1 -max_mem_reads 50000000  -strand  -p 10 
* [Mon Oct 10 22:20:35 2022] Running CMD: /usr/bin/sort --parallel=1 -T . -S 2G -k 1,1n -k3,3nr -k2,2 /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/readsToComponents.out > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/chrysalis/readsToComponents.out.sort
Monday, October 10, 2022: 22:20:35	CMD: mkdir -p /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/read_partitions/Fb_0/CBin_0
Monday, October 10, 2022: 22:20:35	CMD: touch /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/partitioned_reads.files.list.ok
Monday, October 10, 2022: 22:20:35	CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/write_partitioned_trinity_cmds.pl --reads_list_file /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/partitioned_reads.files.list --CPU 1 --max_memory 1G  --run_as_paired  --SS_lib_type F  --seqType fa --trinity_complete --full_cleanup  --no_salmon  > recursive_trinity.cmds
Monday, October 10, 2022: 22:20:35	CMD: touch recursive_trinity.cmds.ok
Monday, October 10, 2022: 22:20:35	CMD: touch recursive_trinity.cmds.ok


--------------------------------------------------------------------------------
------------ Trinity Phase 2: Assembling Clusters of Reads ---------------------
------- (involving the Inchworm, Chrysalis, Butterfly trifecta ) ---------------
--------------------------------------------------------------------------------

Monday, October 10, 2022: 22:20:35	CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/trinity-plugins/BIN/ParaFly -c recursive_trinity.cmds -CPU 1 -v -shuffle 
Number of Commands: 36

succeeded(1)   2.77778% completed.    
succeeded(2)   5.55556% completed.    
succeeded(3)   8.33333% completed.    
succeeded(4)   11.1111% completed.    
succeeded(5)   13.8889% completed.    
succeeded(6)   16.6667% completed.    
succeeded(7)   19.4444% completed.    
succeeded(8)   22.2222% completed.    
succeeded(9)   25% completed.    
succeeded(10)   27.7778% completed.    
succeeded(11)   30.5556% completed.    
succeeded(12)   33.3333% completed.    
succeeded(13)   36.1111% completed.    
succeeded(14)   38.8889% completed.    
succeeded(15)   41.6667% completed.    
succeeded(16)   44.4444% completed.    
succeeded(17)   47.2222% completed.    
succeeded(18)   50% completed.    
succeeded(19)   52.7778% completed.    
succeeded(20)   55.5556% completed.    
succeeded(21)   58.3333% completed.    
succeeded(22)   61.1111% completed.    
succeeded(23)   63.8889% completed.    
succeeded(24)   66.6667% completed.    
succeeded(25)   69.4444% completed.    
succeeded(26)   72.2222% completed.    
succeeded(27)   75% completed.    
succeeded(28)   77.7778% completed.    
succeeded(29)   80.5556% completed.    
succeeded(30)   83.3333% completed.    
succeeded(31)   86.1111% completed.    
succeeded(32)   88.8889% completed.    
succeeded(33)   91.6667% completed.    
succeeded(34)   94.4444% completed.    
succeeded(35)   97.2222% completed.    
succeeded(36)   100% completed.    

All commands completed successfully. :-)



** Harvesting all assembled transcripts into a single multi-fasta file...

Monday, October 10, 2022: 22:21:36	CMD: find /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/read_partitions/ -name '*inity.fasta'  | /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/partitioned_trinity_aggregator.pl --token_prefix TRINITY_DN --output_prefix /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/Trinity.tmp
* [Mon Oct 10 22:21:36 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/salmon_runner.pl Trinity.tmp.fasta /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa 1
* [Mon Oct 10 22:21:37 2022] Running CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/filter_transcripts_require_min_cov.pl Trinity.tmp.fasta /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir/both.fa salmon_outdir/quant.sf 2 > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir.Trinity.fasta
Monday, October 10, 2022: 22:21:37	CMD: /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/util/support_scripts/get_Trinity_gene_to_trans_map.pl /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir.Trinity.fasta > /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir.Trinity.fasta.gene_trans_map


#############################################################################
Finished.  Final Trinity assemblies are written to /root/hpcrunner/tmp/trinityrnaseq-v2.14.0/sample_data/test_Trinity_Assembly/trinity_out_dir.Trinity.fasta
#############################################################################



##### Done Running Trinity #####

if [ $* ]; then
    # check full-length reconstruction stats:

    ${TRINITY_HOME}/util/misc/illustrate_ref_comparison.pl __indiv_ex_sample_derived/refSeqs.fa trinity_out_dir.Trinity.fasta 90

    ./test_FL.sh --query  trinity_out_dir.Trinity.fasta --target __indiv_ex_sample_derived/refSeqs.fa --no_reuse

fi

touch test
```

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                                       | x86信息                     |
| -------- | --------------------------------------------- | --------------------------- |
| 操作系统 | openEuler 20.09                               | openEuler 20.09             |
| 内核版本 | 4.19.90-2110.8.0.0119.oe1.aarch64             | 4.19.90-2003.4.0.0036.oe1.x86_64 |

### 3.2.测试软件环境信息对比

|       | arm信息       | x86信息   |
| ----- | ------------- | --------- |
| gcc   | bisheng 2.1.0    | gcc 9.3.0 |
| bowtie2  | 2.4.5      | 2.4.5     |
| trinity  | 2.14.0     | 2.14.0    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息    |
| ------ | ----------- | ---------- |
| cpu    | Kunpeng 920 | Intel(R) Core(TM) i5-8259U|
| 核心数 | 4           | 8         |
| 内存   | 16 GB       | 16 GB      |
| 磁盘io | 1.3 GB/s    | 1.3 MB/s   |
| 虚拟化 | KVM         | KVM        |

### 3.4.单线程
单线程运行测试时间对比（五次运行取平均值）
|                | arm    | x86    |
| -------------- | -------- | -------- |
| 实际CPU时间    | 2m15.058  | 1m19.252s |
| 用户时间       | 2m5.220s | 1m45.283s |

### 3.5.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86       |
| ----------- | ---------- | --------- |
| 线程数      | 4          | 4         |
| 实际CPU时间 | 0m58.279s  | 0m33.555s |
| 用户时间    | 2m21.631s  | 2m16.764s  |

arm多线程时间耗费数据表：

| 线程          | 1        | 2       | 4       |
| :------------ | -------- | ------- | -------- |
| 用户时间(s)   | 135.058  | 83.990  | 58.279  |
| 用户态时间(s) | 125.220  | 132.509  | 141.631  | 
| 内核态时间(s) | 8.176   | 8.773   | 9.524   |

x86多线程时间耗费数据表：
| 线程          | 1        | 2       | 4       | 8       |
| :------------ | -------- | ------- | -------- | ------- |
| 用户时间(s)   | 79.252 | 50.657 | 33.555  | 32.992  |
| 用户态时间(s) | 105.283  | 124.320 | 132.276 | 165.228 |
| 内核态时间(s) | 12.283   | 12.512   | 12.276  | 15.676 |


## 4.精度测试

### 4.1.所选测试案例

sample_data/test_Trinity_Assembly/reads.left.fq.gz
sample_data/test_Trinity_Assembly/reads.right.fq.gz


### 4.2.获取对比数据

arm 运行结果(部分)

```bash
succeeded(30)   83.3333% completed.    
succeeded(31)   86.1111% completed.    
succeeded(32)   88.8889% completed.    
succeeded(33)   91.6667% completed.    
succeeded(34)   94.4444% completed.    
succeeded(35)   97.2222% completed.    
succeeded(36)   100% completed.    

All commands completed successfully. :-)
```

### 4.3.测试总结
从arm输出结果可以看出所有的测试通过。