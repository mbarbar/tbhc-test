#!/bin/sh

svf=$1
analysis=$2
outdir=$3

if [ "$#" -ne 3 ]; then
    echo "usage: $0 svf-binary analysis-type out-dir"
    exit 1
fi

mkdir "$outdir"

for run in 1 2 3; do
    echo "======== RUN $run ========"
    for f in *.bc; do
        command="/usr/bin/time -o $outdir/$f.$analysis.$run.time $svf -$analysis $f > $outdir/$f.$analysis.$run.svf"
        echo "Running: '$command' for run $run"
        eval $command
    done
done
