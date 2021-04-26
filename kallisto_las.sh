#!/bin/bash

# $1 file dir, /home/wmbio/RNA_SEQ_DNALINKS/CELLINE_RAW_DATA
# $2 out dir, /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_result
# $3 index dir, /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx
# 
# command line variable 
while getopts i:o:x: flag
do
    case "${flag}" in
        i) dir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
    esac
done

# find & unique
file_list=$(find ${dir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'.' -f1 | sort -u)
echo $file_list

for file_name in $file_list
do
    echo $file_name
    kallisto quant -t 30 -i ${indexdir} -o ${outdir}/${file_name} ${dir}/${file_name}.R1.fq.gz ${dir}/${file_name}.R2.fq.gz 
done