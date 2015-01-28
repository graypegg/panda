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
echo -e "${blue}Moving latest build to /usr/local/bin${NC}"
cp build/panda /usr/local/bin/panda
echo -e "${blue}Done${NC}"