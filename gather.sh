#!/bin/sh

svf=$1
analysis=$2

if [ "$#" -ne 2 ]; then
    echo "usage: $0 svf-binary analysis-type"
    exit 1
fi

for f in *.bc; do
    command="/usr/bin/time -o $f.time $svf -$analysis $f > $f.svf"
    echo "Running: '$command'"
    eval $command
done
