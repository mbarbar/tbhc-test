#!/bin/sh

time=`date +%s`
svf="$HOME/svf/Release-build/bin/wpa"

# Two FSPTA runs: one for time (ptr-only SVFG), one for alias testing (full SVFG).
./gather.sh $svf '-fspta'                                   sparse-time-$time     sparse-time      0
./gather.sh $svf '-fspta                  -ctir-alias-eval' sparse-alias-$time    sparse-alias    25
./gather.sh $svf '-fstbhc                 -ctir-alias-eval' typeclone-$time       typeclone       50
./gather.sh $svf '-fstbhc -tbhc-all-reuse -ctir-alias-eval' typeclone-reuse-$time typeclone-reuse 75

./table.awk sparse-time-$time/* sparse-alias-$time/* typeclone-$time/* typeclone-reuse-$time/*
