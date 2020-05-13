#!/bin/sh

svf=$1
analysis_args=$2
outdir=$3
type=$4
pc=$5

if [ "$#" -ne 5 ]; then
    echo "usage: $0 svf-binary analysis-args out-dir type percentage-done"
    exit 1
fi

total_bc=`ls -l *.bc | wc -l`

mkdir "$outdir"

curr_bc=0
for f in *.bc; do
    curr_pc=`echo "$pc + (25/$total_bc) * $curr_bc" | bc -l`
    printf "  ### %2.2f%% done ################ next test: $type for $f ###################  \n" $curr_pc
    echo $type > $outdir/$f.svf
    command="$svf -print-dchg $analysis_args $f >> $outdir/$f.svf"
    echo "        Running: '$command' for '$type'\n"
    eval $command
    curr_bc=`expr $curr_bc + 1`
done
