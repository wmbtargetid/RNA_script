#!/bin/bash

# argument
basedir=$1
filename=$2

while read line; do
# reading each line
    echo $line
    docker run --rm -v ${basedir}/:/data pegi3s/sratoolkit fasterq-dump -e 10 -F --split-files ${line} --outdir /data
done < $filename