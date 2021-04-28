#!/bin/bash

# container name
# tophat, cufflink
# outdir <---- in mounted point, mkdir -p [outdir]/Tophat_result
# outdir <---- in mounted point, mkdir -p [outdir]/cufflinks_result

# e.g) RNA_script/tophat_cuff_pipe.sh -i /data/input_dir/temp -o /data/output_dir -x /data/index -t 8 -g fastq or fq

# command line variable 
while getopts i:o:x:t:g: flag
do
    case "${flag}" in
        i) indir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# dir making
docker exec -it tophat2 /bin/sh -c "mkdir -p ${outdir}/Tophat_result;mkdir -p ${outdir}/cufflinks_result"

# tophat CMD
docker exec tophat2 /bin/sh -c "/data/RNA_script/tophat_pipe.sh -i ${indir} -o ${outdir} -x ${indexdir} -t ${thread} -g ${type}"
# cufflink CMD
docker exec cufflink /bin/sh -c "/data/RNA_script/cufflink_pipe.sh -i ${outdir}/Tophat_result -o ${outdir} -x ${indexdir} -t ${thread}"
