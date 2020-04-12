#!/bin/sh

svf=$1
analysis_args=$2
outdir=$3
runs=$4

if [ "$#" -ne 4 ]; then
    echo "usage: $0 svf-binary analysis-args out-dir #runs"
    exit 1
fi

mkdir "$outdir"

for run in `seq 1 $runs`; do
    echo "======== RUN $run ========"
    for f in *.bc; do
        command="/usr/bin/time -v -o $outdir/$f.$run.time $svf $analysis_args $f > $outdir/$f.$run.svf"
        echo "Running: '$command' for run #$run"
        eval $command
    done
done
