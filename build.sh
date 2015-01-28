#!/bin/bash
red='\033[0;31m'
blue='\033[1;34m'
yellow='\033[1;33m'
NC='\033[0m'
if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root${NC}" 1>&2
   exit 1
fi
build="../build/panda"
cd ./src
fcount=`ls -l ../build/old-builds | wc -l`
if [ $fcount -ge 5 ]; then
	echo -e "${blue}Erasing old builds${NC}"
	cd ../build/old-builds
	rm -R panda*
	cd ../../src
fi
if [ -f $build ]; then
	echo -e "${blue}Moving old build${NC}"
	mv $build "../build/old-builds/panda-`date +%s`"
fi
echo -e "${blue}Starting GHC${NC}"
/usr/bin/time -f "%S" ghc --make -o $build Main 2> temp
ptime=`cat temp`
rm temp
cd ..
if [ -f "panda" ]; then
	echo -e "${blue}Deleting old symbolic link${NC}"
	rm panda
fi
if [ -f "build/panda" ]; then
	echo -e "${blue}Creating symbolic link${NC}"
	ln -s build/panda panda
fi
echo -e "${blue}Done in ${yellow}"$ptime"s${NC}"
