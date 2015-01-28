#!/bin/bash
red='\033[0;31m'
blue='\033[1;34m'
NC='\033[0m'
if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root${NC}" 1>&2
   exit 1
fi
./reset.sh
./build.sh
./install.sh