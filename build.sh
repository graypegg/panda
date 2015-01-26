#!/bin/bash
build="../build/panda"
cd ./src
fcount=`ls -l ../build/old-builds | wc -l`
if [ $fcount -ge 5 ]; then
	echo "Erasing old builds"
	cd ../build/old-builds
	rm -R panda*
	cd ../../src
fi
if [ -f $build ]; then
	echo "Moving old build"
	mv $build "../build/old-builds/panda-`date +%s`"
fi
echo "Starting GHC"
/usr/bin/time -f "%S" ghc --make -o $build Main 2> temp
ptime=`cat temp`
rm temp
echo "Done in "$ptime"s"
cd ..
