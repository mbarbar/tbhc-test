#!/bin/sh

svf=$1
analysis_args=$2
outdir=$3
type=$4

if [ "$#" -ne 4 ]; then
    echo "usage: $0 svf-binary analysis-args out-dir type"
    exit 1
fi

mkdir "$outdir"

echo "======== gather.sh ========"
for f in *.bc; do
    echo $type > $outdir/$f.svf
    command="/usr/bin/time -v -o $outdir/$f.time $svf $analysis_args $f >> $outdir/$f.svf"
    echo "-------- $f --------"
    echo "Running: '$command' for '$type'"
    eval $command
done
