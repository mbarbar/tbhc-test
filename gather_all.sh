#!/bin/sh

./gather.sh ~/clone/svf/Release-build/bin/wpa '-fspta'                  fspta-1f0c-na     10
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc'                 fstbhc-1f0c-nr-na 10
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -tbhc-all-reuse' fstbhc-1f0c-ar-na 10

./gather.sh ~/clone/svf/Release-build/bin/wpa '-fspta -ctir-alias-eval'                  fspta-1f0c-wa     1
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -ctir-alias-eval'                 fstbhc-1f0c-nr-wa 1
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -tbhc-all-reuse -ctir-alias-eval' fstbhc-1f0c-ar-wa 1
