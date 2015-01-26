#!/bin/bash
build="../build/panda-"`date +%s`
cd ./src
echo "Starting GHC"
#ptime=$( { (/usr/bin/time -f "%S" ghc --make -o $build Main) > /dev/null; } 2>&1 )
/usr/bin/time -f "%S" ghc --make -o $build Main 2> temp
ptime=`cat temp`
rm temp
echo "Done in "$ptime"s"
cd ..
