#!/bin/bash

# ./kallisto.sh -i /home/wmbio/DNA_LINKS_DATA/Fastq_BAM/RNASeq_bamtofastq -o /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_result/tissue_DNALINKS -x /home/wmbio/RNA_SEQ_DNALINKS/kallisto/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx


# command line variable 
while getopts n:p:h:b:i:x:t:g: flag
do
    case "${flag}" in
        n) nasid=${OPTARG};;
        p) naspw=${OPTARG};;
        h) nas=${OPTARG};;
        b) basedir=${OPTARG};;
        i) indir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# index file download
if [ ! -d ${basedir}/index ];then
    echo "No Index dir"
    ncftpget -u ${nasid} -p ${naspw} ${nas} ${basedir} /volume1/Data/RNA_SEQ/work/index.tar.gz
    tar -xzvf index.tar.gz -C ${basedir}
else
    echo "Index dir exist!"
fi

# kallisto docker
docker run --rm -dit -v ${basedir}:/data --name kallisto zlskidmore/kallisto:latest /bin/bash

# output_dir
docker exec -it kallisto /bin/sh -c "mkdir -p /data/kallisto_output;chmod -R 777 /data/kallisto_output"

# kallisto CMD
echo "KALLISTO RUN!!!!!!!!"
docker exec kallisto /bin/sh -c "/data/RNA_script/kallisto_pipe.sh -i /data/output_dir/QC -o /data/kallisto_output -x /data/${indexdir}/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx -t ${thread} -g ${type}"

