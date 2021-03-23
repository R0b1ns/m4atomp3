#!/bin/bash

# brogit (c) 2021
# Author: r0b1ns

SCRIPT_DIRECTORY="$( cd "$(dirname "$0")" ; pwd -P )"

source="$SCRIPT_DIRECTORY"

if [ $1 ]; then
	if [ $1 == "--help" ]; then
		echo "Usage: $0 {sourcepath, {destinationpath}}"
		exit 1
	elif test -d "$1"; then
		source="$1"
	else
		echo "Invalid source directory "
	fi
fi

destination="$source"

if [ $2 ]; then
	if test -d "$2"; then
		destination="$2"
	else
		echo "Invalid destination directory"
	fi
fi

echo "Source: $source"
echo "destination: $destination"

read -p "Should all '*.m4a' be converted to '*.mp3'?  (y/n) " yn
if ! [[ $yn =~ ^[Yy]$ ]]
then
  echo "Abbruch"
  exit 2
fi

removesource=true

read -p "Should all source files be deleted after converting? (y/n) " yn
if ! [[ $yn =~ ^[Yy]$ ]]
then
  echo "Source files are not deleted "
  removesource=false
fi

for file in $source/*.m4a
do
	ffmpeg -v 5 -y -i "$file" -acodec libmp3lame -ac 2 -ab 192k "${file%.*}.mp3"
	
	if $removesource; then
		rm "$file"
	fi

	echo "Done: ${file%.*}.mp3"
done