#!/bin/bash

while getopts i:o::x:t:g: flag
do
    case "${flag}" in
        i) indir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done



# find & unique, delemeter
file_list=$(find ${indir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'_' -f1 | sort -u)
echo $file_list

# run tophat2
for file_name in $file_list
do
    echo $file_name  #K1Aligned_Access_R1.fastq.gz
    tophat2 --num-threads ${thread} -G ${indexdir}/gencode.v37.primary_assembly.annotation.gtf -o ${outdir}/Tophat_result/${file_name} ${indexdir}/hg38 ${indir}/${file_name}_R1.${type}.gz ${indir}/${file_name}_R2.${type}.gz
done
