#!/bin/bash
red='\033[0;31m'
blue='\033[1;34m'
NC='\033[0m'
if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root${NC}" 1>&2
   exit 1
fi
installCabal () {
	echo -e "${blue}Intalling Cabal and GHC Runtime${NC}"
	sudo apt-get install ghc
}
command -v cabal >/dev/null 2>&1 || { installCabal; exit 1; }
echo -e "${blue}Installing Options${NC}"
cabal install Options
echo -e "${blue}Installing Split${NC}"
cabal install split
echo -e "${blue}Done${NC}"