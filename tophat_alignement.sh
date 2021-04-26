#!/bin/bash

# tophat container, ~/RNA_SEQ_DNALINKS ----> /root, tophat container
# cufflinks -p 4 -o cufflinks_result/Hct8_WT -G index/gencode.v37.primary_assembly.annotation.gtf Tophat_result/Hct8_WT/accepted_hits.bam
# $1 file dir, /raw_data/Fastq
# $2 out dir, /data/work/ALL_CK_LAS/ALL_ensemble/Tophat_result
# $3 index dir, /data/work/ALL_CK_DNALINK/ALL_ensemble/index
# ex) ./tophat_alignement.sh /raw_data/Fastq_BAM/RNASeq_bamtofastq /data/work/ALL_CK_DNALINK/ALL_ensemble/Tophat_result /data/work/ALL_CK_DNALINK/ALL_ensemble/index C

# command line variable 
dir=$1
outdir=$2
indexdir=$3
#startword=$4

# find & unique
file_list=$(find ${dir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'_' -f1 | sort -u)
echo $file_list

for file_name in $file_list
do
    echo $file_name
    tophat2 --num-threads 15 -G ${indexdir}/gencode.v37.primary_assembly.annotation.gtf -o ${outdir}/${file_name} ${indexdir}/hg38 ${dir}/${file_name}_R1.fastq.gz ${dir}/${file_name}_R2.fastq.gz
done