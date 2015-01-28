#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
if [ -f "/usr/local/bin/panda" ]; then
	echo "Deleting old installed build"
	sudo rm /usr/local/bin/panda
fi
echo "Moving latest build to /usr/local/bin"
cp build/panda /usr/local/bin/panda
echo "Done"