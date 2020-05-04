#!/bin/sh

# Two FSPTA runs: one for time (ptr-only SVFG), one for alias testing (full SVFG).
./gather.sh $1 '-fspta'                                   fspta-time   fspta-time
./gather.sh $1 '-fspta                  -ctir-alias-eval' fspta-alias  fspta-alias
./gather.sh $1 '-fstbhc                 -ctir-alias-eval' fstbhc       fstbhc
./gather.sh $1 '-fstbhc -tbhc-all-reuse -ctir-alias-eval' fstbhc-reuse fstbhc-reuse

./table.awk fspta-time/* fspta-alias/* fstbhc/* fstbhc-reuse/*
