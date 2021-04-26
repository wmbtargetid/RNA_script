#!/bin/bash

while getopts i:o::x:t: flag
do
    case "${flag}" in
        i) indir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
    esac
done



# find & unique, delemeter
file_list=$(find ${indir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'.' -f1 | sort -u)
echo $file_list

# run tophat2
for file_name in $file_list
do
    echo $file_name
    tophat2 --num-threads ${thred} -G ${indexdir}/gencode.v37.primary_assembly.annotation.gtf -o ${outdir}/Tophat_result/${file_name} ${indexdir}/hg38 ${indir}/${file_name}.R1.fq.gz ${indir}/${file_name}.R2.fq.gz
done