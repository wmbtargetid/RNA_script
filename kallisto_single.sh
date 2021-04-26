#!/bin/bash

# ./kallisto.sh -i /home/wmbio/DNA_LINKS_DATA/Fastq_BAM/RNASeq_bamtofastq -o /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_result/tissue_DNALINKS -x /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx


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
file_list=$(find ${dir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'_' -f1 | sort -u)
echo $file_list

for file_name in $file_list
do
    echo $file_name
    kallisto quant -t 8 -i ${indexdir} -o ${outdir}/${file_name} -b 100 --single -l 180 -s 20 ${dir}/${file_name}_1.fastq.gz
done