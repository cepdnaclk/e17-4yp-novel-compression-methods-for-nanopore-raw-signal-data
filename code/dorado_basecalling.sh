#!/bin/bash

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --model=*)
      model="${1#*=}"
      ;;
    --file-path=*)
      file_path="${1#*=}"
      ;;
    --output-file=*)
      output_file="${1#*=}"
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
  shift
done


#check for correct options
if [ -z "$model" ] || [ -z "$file_path" ]; then
  echo "Usage: $0 --model=<model_name> --file-path=<path_to_file>"
  exit 1
fi


#basecall
slow5-dorado basecaller $model --emit-fastq $file_path > ${output_file}.fastq

#align
minimap2 -cx map-ont ../hg38noAlt.idx -t32 --secondary=no ${output_file}.fastq | awk '{print $10/$11}' > identity_scores_${output_file}.txt

#print mean and meadian identity scores
datamash mean 1 median 1 < identity_scores_${output_file}.txt
