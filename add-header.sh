#!/bin/bash

FILELIST=""
LICENSE_FILE=""
WORKING_FILE="tmp.rs"
COUNT=0

usage() {
	echo "" 1>&2
	echo "Add license comment to head of source files." 1>&2
	echo "" 1>&2
	echo "Usage: $0 -l filelist -s license_file" 1>&2
	echo "" 1>&2
}

if [ "$#" -ne 4 ]; then
	usage
	exit 1
fi

while getopts ':l:s:h' opt; do
	case $opt in
		l)
			FILELIST=$OPTARG
			;;
		s)
			LICENSE_FILE=$OPTARG
			;;
		h)
			usage
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument"
			exit 1
			;;
		*)
			echo "Invalid option: -$OPTARG"
			usage
			exit 1
			;;
	esac
done

while read file; do
	if ! [ -f $file ]; then
		echo "File: $file not found." 1>&2
		continue;
	fi
	cat $LICENSE_FILE > $WORKING_FILE
	echo "" >> $WORKING_FILE
	cat $file >> $WORKING_FILE
	mv $WORKING_FILE $file
	echo "Add license header into $file ..."
	let COUNT+=1
done < $FILELIST

echo "Total $COUNT files are processed"
exit 0
