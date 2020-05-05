#!/bin/sh

# Two FSPTA runs: one for time (ptr-only SVFG), one for alias testing (full SVFG).
./gather.sh $1 '-fspta'                                   sparse-time     sparse-time      0
./gather.sh $1 '-fspta                  -ctir-alias-eval' sparse-alias    sparse-alias    25
./gather.sh $1 '-fstbhc                 -ctir-alias-eval' typeclone       typeclone       50
./gather.sh $1 '-fstbhc -tbhc-all-reuse -ctir-alias-eval' typeclone-reuse typeclone-reuse 75

./table.awk sparse-time/* sparse-alias/* typeclone/* typeclone-reuse/*
