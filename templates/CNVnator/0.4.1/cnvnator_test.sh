#!/bin/bash

set -e

cd ${JARVIS_TMP_DOWNLOAD}/CNVnator_v0.4.1/ExampleData/
#该测试BAM文件仅作为cnvnator命令使用参考的小demo。若需包含拷贝数变异CNV测试请自行以实际为准
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr20.fa.gz
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam

gunzip chr20.fa.gz
mv NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam NA12878_ali.bam
../src/samtools/bin/samtools index NA12878_ali.bam
../src/samtools/bin/samtools faidx chr20.fa

../src/cnvnator -root NA12878_ali.root -tree NA12878_ali.bam -chrom 20
../src/cnvnator -root NA12878_ali.root -his 1000 -chrom 20
../src/cnvnator -root NA12878_ali.root -stat 1000
../src/cnvnator -root NA12878_ali.root -partition 1000
../src/cnvnator -root NA12878_ali.root -call 1000 > cnv_calls.txt
../src/cnvnator2VCF.pl -prefix sample -reference hg19 chr20.fa cnv_calls.txt > NA12878_ali.cnv.vcf
#检查VCF头部信息
grep "^#" NA12878_ali.cnv.vcf
