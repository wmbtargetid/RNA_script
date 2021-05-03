# command line variable 
while getopts i:o:x:t:g: flag
do
    case "${flag}" in
        i) dir=${OPTARG};;
        o) outdir=${OPTARG};;
        x) indexdir=${OPTARG};;
        t) thread=${OPTARG};;
        g) type=${OPTARG};;
    esac
done

# find & unique
file_list=$(find ${dir} -maxdepth 1 -type f -exec basename "{}" \; | cut -d'_' -f1 | sort -u)
echo $file_list

for file_name in $file_list
do
    echo $file_name
    kallisto quant -t ${thread} -i ${indexdir} -o ${outdir}/${file_name} ${dir}/${file_name}_R1_val_1.${type}.gz ${dir}/${file_name}_R2_val_2.${type}.gz 
done