#!/bin/bash
run () {
	echo "Removing pointer files"
	cd ./src
	rm *.o *.hi
	echo "Removing current build"
	cd ../build
	rm panda
	echo "Removing old builds"
	cd old-builds
	rm -R panda*
	echo "Removing old symbolic link"
	cd ../..
	rm panda
	echo "Done"
}
while true; do
    read -p "Are you sure? " yn
    case $yn in
        [Yy]* ) run; break;;
        [Nn]* ) exit;;
        * ) echo "Unknown input, please enter y or n.";;
    esac
done