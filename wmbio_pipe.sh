#!/bin/bash

# tophat, cufflink
# RUN ex) RNA_script/wmbio_pipe.sh -r a -n jinoo -p Wmlswkdia1! -h 192.168.0.90 -b /home/wmbio/temp -i input_dir -x index -t 30 -g fq
# command line variable 
while getopts r:n:p:h:b:i:t:g: flag
do
    case "${flag}" in
        r) run=${OPTARG};;
        n) nasid=${OPTARG};;
        p) naspw=${OPTARG};;
        h) nas=${OPTARG};;
        b) basedir=${OPTARG};;
        i) indir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# # RNA-Seq script
# git clone https://github.com/Jin0331/RNA_script.git ${basedir}/RNA_script


# index file download
if [ ! -d ${basedir}/index ];then
    echo "Index dir not exist!"
    ncftpget -u ${nasid} -p ${naspw} ${nas} ${basedir} /Data/RNA_SEQ/work/index.tar.gz
    tar -xzvf index.tar.gz -C ${basedir}
else
    echo "Index dir exist!"
fi




## Docker run
docker stop trim_galore tophat2 cufflink kallisto && docker rm trim_galore tophat2 cufflink kallisto
echo "Trim Galore, Tophat2, Cufflink, Kallisto Docker Container RUN!!!"
# trimgalore
docker run --rm -dit -v ${basedir}:/data --name trim_galore dukegcb/trim-galore:latest /bin/bash
# kallisto docker
docker run --rm -dit -v ${basedir}:/data --name kallisto zlskidmore/kallisto:latest /bin/bash
# tophat container
docker run --rm -dit -v ${basedir}:/data --name tophat2 genomicpariscentre/tophat2:latest /bin/bash
# cufflink container
docker run --rm -dit -v ${basedir}:/data --name cufflink fomightez/rnaseqcufflinks:latest /bin/bash

# dir making
docker exec -it tophat2 /bin/sh -c "mkdir -p /data/output_dir/QC; mkdir -p /data/output_dir/Tophat_result;mkdir -p /data/output_dir/cufflinks_result;mkdir -p /data/output_dir/kallisto_result;chmod -R 777 /data/output_dir"

## RUN pipeline
# trim_galore CMD
echo "Trim Galore RUN!!!!!!!!"
docker exec trim_galore /bin/sh -c "/data/RNA_script/trim_galore_pipe.sh -i /data/${indir} -o /data/output_dir"

if [ ${run} = "a" ];then

    # kallisto CMD
    echo "KALLISTO RUN!!!!!!!!"
    docker exec kallisto /bin/sh -c "/data/RNA_script/kallisto_pipe.sh -i /data/output_dir/QC -o /data/output_dir/kallisto_result -x /data/index/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx -t ${thread} -g ${type}"

    # tophat CMD
    echo "Tophat2 RUN!!!!!!!!"
    docker exec tophat2 /bin/sh -c "/data/RNA_script/tophat_pipe.sh -i /data/output_dir/QC -o /data/output_dir -x /data/index/genome_index -t ${thread} -g ${type}"

    # cufflink CMD
    echo "CUFFLINKS RUN!!!!!!!!"
    docker exec cufflink /bin/sh -c "/data/RNA_script/cufflink_pipe.sh -i /data/output_dir/Tophat_result -o /data/output_dir -x /data/index/genome_index -t ${thread}"
    # done
    echo "DONE!!!"
    docker stop trim_galore tophat2 cufflink kallisto

elif [ ${run} = "k" ];then

    # kallisto CMD
    echo "KALLISTO RUN!!!!!!!!"
    docker exec kallisto /bin/sh -c "/data/RNA_script/kallisto_pipe.sh -i /data/output_dir/QC -o /data/output_dir/kallisto_result -x /data/index/kallisto_index/Homo_sapiens.GRCh38.cdna.all_add_RON_del.idx -t ${thread} -g ${type}"

    echo "DONE!!!"
    docker stop trim_galore tophat2 cufflink kallisto

elif [ ${run} = "t" ];then
    # tophat CMD
    echo "Tophat2 RUN!!!!!!!!"
    docker exec tophat2 /bin/sh -c "/data/RNA_script/tophat_pipe.sh -i /data/output_dir/QC -o /data/output_dir -x /data/index/genome_index -t ${thread} -g ${type}"

    # cufflink CMD
    echo "CUFFLINKS RUN!!!!!!!!"
    docker exec cufflink /bin/sh -c "/data/RNA_script/cufflink_pipe.sh -i /data/output_dir/Tophat_result -o /data/output_dir -x /data/index/genome_index -t ${thread}"

    echo "DONE!!!"
    docker stop trim_galore tophat2 cufflink kallisto

else
    echo "No Run type!!!"
fi
