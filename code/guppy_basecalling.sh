#!/bin/bash

# Default values for command-line arguments
config_file=""
input_file=""
output_fastq=""
reference_index=""
device="cuda:all"
port=5555
guppy_path="/path/to/guppy"  # Default Guppy path

show_help() {
  cat <<EOM
Usage: $0 --config=<config_file> --input-file=<input_file> --output-fastq=<output_fastq> --reference-index=<reference_index> [--device=<device>] [--port=<port>] [--guppy=<guppy_path>]

Options:
  --config=<config_file>         Specify the configuration file.
  --input-file=<input_file>     Specify the input file.
  --output-fastq=<output_fastq> Specify the output fastq file.
  --reference-index=<reference_index> Specify the reference index file.
  --device=<device>             Specify the device (default: cuda:all).
  --port=<port>                 Specify the port (default: 5555).
  --guppy=<guppy_path>          Specify the path to Guppy (default: /path/to/guppy).
  -h, --help                    Display this help message.
EOM
}

die() {
  echo "$1" >&2
  echo
  exit 1
}

# Parse command-line arguments using a while loop
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --config=*)
      config_file="${1#*=}"
      ;;
    --input-file=*)
      input_file="${1#*=}"
      ;;
    --output-fastq=*)
      output_fastq="${1#*=}"
      ;;
    --reference-index=*)
      reference_index="${1#*=}"
      ;;
    --device=*)
      device="${1#*=}"
      ;;
    --port=*)
      port="${1#*=}"
      ;;
    --guppy=*)
      guppy_path="${1#*=}"
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Invalid option: $1"
      show_help
      exit 1
      ;;
  esac
  shift
done

# Check for required options
if [ -z "$config_file" ] || [ -z "$input_file" ] || [ -z "$output_fastq" ] || [ -z "$reference_index" ]; then
  echo "Error: Missing required options."
  show_help
  exit 1
fi

# Check if the specified Guppy path exists
if [ ! -d "$guppy_path" ]; then
  die "Error: Guppy path '$guppy_path' does not exist."
fi

# Check if 'buttery-eel' is installed
buttery_eel_version=$(buttery-eel --version 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$buttery_eel_version" ]; then
  die "Error: 'buttery-eel' not found or not configured properly."
fi

# Run buttery-eel with specified arguments
buttery-eel --config "$config_file" --device "$device" -i "$input_file" -o "$output_fastq" -g "$guppy_path" --port "$port" || die "Error: 'buttery-eel' command failed."

# Check if 'minimap2' is installed
minimap2_version=$(minimap2 --version 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$minimap2_version" ]; then
  die "Error: 'minimap2' not found or not configured properly."
fi

# Run minimap2 and calculate identity scores
minimap2 -cx map-ont "$reference_index" -t8 --secondary=no "$output_fastq" > allignments.paf || die "Error: 'minimap2' command failed."

# Calculate mean identity scores
awk '{print $10/$11}' < allignments.paf > identity_scores.txt

# Check if 'datamash' is installed
datamash_version=$(datamash --version 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$datamash_version" ]; then
  die "Error: 'datamash' not found or not configured properly."
fi

# Use datamash to calculate mean and median
datamash mean 1 median 1 < identity_scores.txt > mean_and_median.txt
