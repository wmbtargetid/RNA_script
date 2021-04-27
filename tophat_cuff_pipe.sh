#!/bin/bash

# container name
# tophat, cufflink

# outdir <---- in mounted point, mkdir -p [temp]/Tophat_result
# outdir <---- in mounted point, mkdir -p [temp]/cufflinks_result

# command line variable 
while getopts i:o:x:t: flag
do
    case "${flag}" in
        i) indir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
    esac
done

# tophat CMD
#docker exec test_1 /bin/sh -c "/data/script/tophat_pipe.sh -i ${indir} -o ${outdir} -x ${indexdir} -t ${thread}"


# cufflink CMD
docker exec test_2 /bin/sh -c "/data/script/cufflink_pipe.sh -i ${outdir}/Tophat_result -o ${outdir} -x ${indexdir} -t ${thread}"
