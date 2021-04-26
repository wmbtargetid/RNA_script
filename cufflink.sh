#!/bin/bash

# cufflinks container, ~/RNA_SEQ_DNALINKS ----> /data, cufflink container
# cufflinks -p 4 -o cufflinks_result/Hct8_WT -G index/gencode.v37.primary_assembly.annotation.gtf Tophat_result/Hct8_WT/accepted_hits.bam
# $1 file dir, /raw_data/Fastq
# $2 out dir, /data/work/ALL_CK_LAS/ALL_ensemble/Tophat_result
# $3 index dir, /data/work/ALL_CK_DNALINK/ALL_ensemble/index

# command line variable 
dir=$1
outdir=$2
indexdir=$3
numthread=$4

# find & unique
# run tophat2
#echo $dir/*
for file_name in $dir/*
do
    cell_name=$(echo $file_name | grep -P '(?<=Tophat_result/)[a-zA-Z0-9]+' -o)
    echo $cell_name
    cufflinks --num-threads ${numthread} -o ${outdir}/${cell_name} -G ${indexdir}/gencode.v37.primary_assembly.annotation.gtf ${dir}/${cell_name}/accepted_hits.bam
done