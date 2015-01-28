#!/bin/bash
resetFiles () {
	if ls src/*.o 1> /dev/null 2>&1; then
		echo "Removing pointer files"
		cd src
		rm *.o *.hi
		cd ../
	fi
	if [ -f "build/panda" ]; then
		echo "Removing current build"
		cd build
		rm panda
		cd ../
	fi
	if ls build/old-builds/panda* 1> /dev/null 2>&1; then
		echo "Removing old builds"
		cd build/old-builds
		rm panda*
		cd ../..
	fi
	if ls panda 1> /dev/null 2>&1; then
		echo "Removing old symbolic link"
		rm panda
	fi
}
run () {
	TIMEFORMAT='%lU';time ( resetFiles ) 2>temp
	ptime=`cat temp`
	rm temp
	echo "Done in "$ptime
}
while true; do
    read -p "Are you sure? " yn
    case $yn in
        [Yy]* ) run; break;;
        [Nn]* ) exit;;
        * ) echo "Unknown input, please enter y or n.";;
    esac
done