#!/bin/bash
red='\033[0;31m'
blue='\033[1;34m'
yellow='\033[1;33m'
NC='\033[0m'
if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root${NC}" 1>&2
   exit 1
fi
resetFiles () {
	if ls src/*.o 1> /dev/null 2>&1; then
		echo -e "${blue}Removing pointer files${NC}"
		cd src
		rm *.o *.hi Cmd/*.o Cmd/*.hi
		cd ../
	fi
	if [ -f "build/panda" ]; then
		echo -e "${blue}Removing current build${NC}"
		cd build
		rm panda
		cd ../
	fi
	if ls build/old-builds/panda* 1> /dev/null 2>&1; then
		echo -e "${blue}Removing old builds${NC}"
		cd build/old-builds
		rm panda*
		cd ../..
	fi
	if ls panda 1> /dev/null 2>&1; then
		echo -e "${blue}Removing old symbolic link${NC}"
		rm panda
	fi
}
run () {
	TIMEFORMAT='%lU';time ( resetFiles ) 2>temp
	ptime=`cat temp`
	rm temp
	echo -e "${blue}Done in ${yellow}"$ptime"${NC}"
}
while true; do
    read -p "Are you sure you want to reset? " yn
    case $yn in
        [Yy]* ) run; break;;
        [Nn]* ) exit;;
        * ) echo -e "${red}Unknown input, please enter y or n.${NC}";;
    esac
done