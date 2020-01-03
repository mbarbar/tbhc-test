#!/bin/sh

svf=$1
analysis=$2
outdir=$3

if [ "$#" -ne 3 ]; then
    echo "usage: $0 svf-binary analysis-type out-dir"
    exit 1
fi

mkdir "$outdir"

for f in *.bc; do
    command="/usr/bin/time -o $outdir/$f.$analysis.time $svf -$analysis $f > $outdir/$f.$analysis.svf"
    echo "Running: '$command'"
    eval $command
done
