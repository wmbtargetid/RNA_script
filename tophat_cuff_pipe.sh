#!/bin/bash

# tophat, cufflink
# e.g)RNA_script/tophat_cuff_pipe.sh -b /home/wmbio/temp -i input_dir -x index -t 10 -g fastq

# command line variable 
while getopts b:i:x:t:g: flag
do
    case "${flag}" in
        b) basedir=${OPTARG};;
        i) indir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# # RNA-Seq script
# git clone https://github.com/Jin0331/RNA_script.git ${basedir}/RNA_script

# index file download

# tophat container
docker run -dit -v ${basedir}:/data --name tophat2 genomicpariscentre/tophat2:latest /bin/bash
# cufflink container
docker run -dit -v ${basedir}:/data --name cufflink fomightez/rnaseqcufflinks:latest /bin/bash

# dir making
docker exec -it tophat2 /bin/sh -c "mkdir -p /data/output_dir/Tophat_result;mkdir -p /data/output_dir/cufflinks_result;chmod -R 777 /data/output_dir"

# tophat CMD
docker exec tophat2 /bin/sh -c "/data/RNA_script/tophat_pipe.sh -i /data/${indir} -o /data/output_dir -x /data/${indexdir} -t ${thread} -g ${type}"
# cufflink CMD
docker exec cufflink /bin/sh -c "/data/RNA_script/cufflink_pipe.sh -i /data/output_dir/Tophat_result -o /data/output_dir -x /data/${indexdir} -t ${thread}"

docker stop tophat2 cufflink && docker rm tophat2 cufflink 