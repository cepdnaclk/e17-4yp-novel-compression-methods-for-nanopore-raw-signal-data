#!/bin/bash

# terminate script
die() {
	echo "$1" >&2
	echo
	exit 1
}

if [ $# -ne 1 ]; then
    die "Usage: $0 <file.blow5>"
fi

[ -z ${SIGTK} ] && export SIGTK=sigtk
${SIGTK} --version &> /dev/null || die "sigtk not found! Either put sigtk under path or set SIGTK variable, e.g.,export SIGTK=/path/to/sigtk"

for ((COUNT = 0; COUNT <= 8; COUNT++)); do
    echo "Iteration $COUNT"
    echo "Running sigtk qts for $1"
    ${SIGTK} qts -b $COUNT --method=round $1 -o rounded_$COUNT.blow5
done
