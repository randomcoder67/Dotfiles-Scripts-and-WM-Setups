#!/usr/bin/env bash

oldIFS="$IFS"
IFS=$'\n'

files=( $(find . -maxdepth 1 -type f | grep -i heic) )

for file in "${files[@]}"; do
	echo "Converting ${file} to jpg"
	file_name_without_extension="${file%.*}"
	magick "${file}" "${file_name_without_extension}.jpg"
done

echo "All done"
