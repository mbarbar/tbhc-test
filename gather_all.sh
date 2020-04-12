#!/bin/sh

./gather.sh ~/clone/svf/Release-build/bin/wpa '-fspta'                  fspta-f0026-na     10
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc'                 fstbhc-f0026-nr-na 10
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -tbhc-all-reuse' fstbhc-f0026-ar-na 10

./gather.sh ~/clone/svf/Release-build/bin/wpa '-fspta -ctir-alias-eval'                  fspta-f0026-wa     1
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -ctir-alias-eval'                 fstbhc-f0026-nr-wa 1
./gather.sh ~/clone/svf/Release-build/bin/wpa '-fstbhc -tbhc-all-reuse -ctir-alias-eval' fstbhc-f0026-ar-wa 1
