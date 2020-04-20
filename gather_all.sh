#!/bin/sh

./gather.sh $1 '-fspta'                  fspta-1f0c-na     10
./gather.sh $1 '-fstbhc'                 fstbhc-1f0c-nr-na 10
./gather.sh $1 '-fstbhc -tbhc-all-reuse' fstbhc-1f0c-ar-na 10

./gather.sh $1 '-fspta -ctir-alias-eval'                  fspta-1f0c-wa     1
./gather.sh $1 '-fstbhc -ctir-alias-eval'                 fstbhc-1f0c-nr-wa 1
./gather.sh $1 '-fstbhc -tbhc-all-reuse -ctir-alias-eval' fstbhc-1f0c-ar-wa 1
