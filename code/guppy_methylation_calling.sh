#!/bin/bash

show_help() {
  cat <<EOM
Usage: $0 -p <port> -d <cuda_devices> -t <threads> -m <model> file.blow5

Options:
  -p,    Specify the port.
  -d,    Specify CUDA devices. eg- "0,1,2"
  -t,    Specify the number of threads.
  -m,    name or the path to the model
  -h,    Display this help message.

Description:
  Given a blow5 file, run everything to the graph

EOM
}

die() {
	echo "$1" >&2
	echo
	exit 1
}

cmd_not_found(){
    echo "$1 not found! Either put $1 under path or set $1 variable, e.g.,export $1=/path/to/$1"
}

# default values (Edit the file paths)
port=5557
devices="0,1"
threads=40
index=$hg/hg38noAlt.idx
reference=$hg/hg38noAlt.fa
truthset=$hg/chr22_bi.tsv
compare_py=$scripts/compare_methylation.py
plot_r=$scripts/corr.r


[ -z ${BUTTERY_EEL} ] && export BUTTERY_EEL=buttery-eel
${BUTTERY_EEL} --version &> /dev/null || die "$(cmd_not_found buttery-eel)"

[ -z ${SAMTOOLS} ] && export SAMTOOLS=samtools
${SAMTOOLS} --version &> /dev/null || die "$(cmd_not_found samtools)"

[ -z ${MODKIT} ] && export MODKIT=modkit
${MODKIT} --version &> /dev/null || die "$(cmd_not_found modkit)"


while getopts ":p:d:t:m:h" opt; do
  case $opt in
    p)
      port="$OPTARG"
      ;;
    d)
      devices="$OPTARG"
      ;;
    t)
      threads="$OPTARG"
      ;;
    m)
      model="$OPTARG"
      ;;
    h)
      # Display help message and exit
      show_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
	  show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))


echo "File Name: $1";
filename=$(basename $1)
name="${filename%.*}"
if [ -z "$name" ]; then
  echo "No input file specified"
  show_help
  exit 1
fi
echo "Running for $name on port $port with cuda $devices"

${BUTTERY_EEL}  -g $guppy --config $model  --device cuda:${devices} -i $1 -o $name.sam --call_mods --port $port \
	     || die "Basecalling failed"
${SAMTOOLS} fastq -TMM,ML $name.sam |  minimap2 -x map-ont -a -t $threads -y --secondary=no $index - | samtools sort -@$threads - > ${name}_mapped.bam \
													     || die "failed creating bam file"
${SAMTOOLS} index  ${name}_mapped.bam || die
#modbam2bed --cpg -m 5mC -t $threads $reference ${name}_mapped.bam > $name.bedmethyl
${MODKIT} pileup --cpg --ref $reference --ignore h -t 32  ${name}_mapped.bam $name.bedmethyl || die "failed at modkit"
grep "chr22" $name.bedmethyl | grep -v nan  > ${name}_chr22.bedmethyl
python3 $compare_py $truthset ${name}_chr22.bedmethyl > ${name}_bi_vs_remora.tsv || die "failed creating bi_vs_remora"
R --no-save --args ${name}_bi_vs_remora.tsv < $plot_r



