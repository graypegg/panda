#!/bin/bash
red='\033[0;31m'
blue='\033[1;34m'
NC='\033[0m'
if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root${NC}" 1>&2
   exit 1
fi
if [ -f "/usr/local/bin/panda" ]; then
	echo -e "${blue}Deleting old installed build${NC}"
	sudo rm /usr/local/bin/panda
fi
if ls build/old-builds/panda-* 1> /dev/null 2>&1; then
	echo -e "${NC}Current build [c] or old build [o] ?"
	read x
	if [ "~$x" == '~o' ]; then
		echo -e "${NC}Please enter time stamp from build name"
		read build
		if [ -f "build/old-builds/panda-$build" ]; then
			echo "This build is from:"
			date -d "@$build" +"%d-%m-%Y %I:%M:%S%p"
			echo "Continue? [y/n]"
			read x
			if [ $x == "y" ]; then
				echo -e "${blue}Moving build number $build to /usr/local/bin${NC}"
				cp "build/old-builds/panda-$build" /usr/local/bin/panda
			fi
		else
			echo -e "${red}Unknown build number!${NC}"
		fi
	else
		echo -e "${blue}Moving latest build to /usr/local/bin${NC}"
		cp build/panda /usr/local/bin/panda
	fi
else
	echo -e "${blue}Moving latest build to /usr/local/bin${NC}"
	cp build/panda /usr/local/bin/panda
fi
echo -e "${blue}Done${NC}"