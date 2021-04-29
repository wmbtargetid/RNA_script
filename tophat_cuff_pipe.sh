#!/bin/bash

# tophat, cufflink
# e.g) RNA_script/tophat_cuff_pipe.sh -i /data/input_dir/temp -o /data/output_dir -x /data/index -t 8 -g fastq or fq

# command line variable 
while getopts b:i:o:x:t:g: flag
do
    case "${flag}" in
        b) basedir=${OPTARG};;
        i) indir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# RNA-Seq script
git clone https://github.com/Jin0331/RNA_script.git ${basedir}/RNA_script

# tophat container
docker run -dit -v ${basedir}:/data --name tophat2 genomicpariscentre/tophat2:latest /bin/bash
# cufflink container
docker run -dit -v ${basedir}:/data --name cufflink fomightez/rnaseqcufflinks:latest /bin/bash

# dir making
docker exec -it tophat2 /bin/sh -c "mkdir -p ${outdir}/Tophat_result;mkdir -p ${outdir}/cufflinks_result"

# tophat CMD
docker exec tophat2 /bin/sh -c "/data/RNA_script/tophat_pipe.sh -i ${indir} -o ${outdir} -x ${indexdir} -t ${thread} -g ${type}"
# cufflink CMD
docker exec cufflink /bin/sh -c "/data/RNA_script/cufflink_pipe.sh -i ${outdir}/Tophat_result -o ${outdir} -x ${indexdir} -t ${thread}"

docker stop tophat2 cufflink && docker rm tophat2 cufflink 