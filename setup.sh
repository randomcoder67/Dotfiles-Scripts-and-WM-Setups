#!/usr/bin/env bash

if [[ "$1" == "--init" ]]; then
	./init.sh
	exit
fi

file_list="$2"
if ! find "file_lists" -maxdepth 1 -type f | grep -E "/${file_list}.txt$"; then
	echo "File list: ${file_list} doesn't exist, options are:"
	ls file_lists
	exit
fi

repo_folder_name="$file_list"
file_list="file_lists/${file_list}.txt"

username="$(whoami)"

FAKE_HOME="fake_home"
oldIFS="$IFS"
IFS=$'\n'
files=( $(cat "$file_list") )
IFS="$oldIFS"

if [[ "$1" == "--save" ]]; then
	# Make sure all the dirs exist
	for f in "${files[@]}"; do
		dir="$(dirname "$f")"
		fake_dir="${dir/\~/$repo_folder_name}"
		[ -d "$fake_dir" ] || mkdir -p "$fake_dir"
	done

	# Copy actual files
	for f in "${files[@]}"; do
		src="${f/\~/$HOME}"
		echo $src
		if $(grep -q "#### SUBSTITUTE" "$src"); then
			./substitute.sh --save "$src" "$repo_folder_name"
		else
			dest="${f/\~/$repo_folder_name}"
			echo $dest
			sed "s/"$username"/USER_USERNAME/g" "$src" > "$dest"
		fi
	done
elif [[ "$1" == "--make" ]]; then
	# Make sure all the dirs exist
	for f in "${files[@]}"; do
		dir="$(dirname "$f")"
		fake_dir="${dir/\~/$FAKE_HOME}"
		[ -d "$fake_dir" ] || mkdir -p "$fake_dir"
	done

	# Copy actual files
	for f in "${files[@]}"; do
		src="${f/\~/$repo_folder_name}"
		dest="${f/\~/$FAKE_HOME}"
		if $(grep -q "#### SUBSTITUTE" "$src"); then
			./substitute.sh --make "$src" "$repo_folder_name" "$dest"
		else
			sed "s/USER_USERNAME/"$username"/g" "$src" > "$dest"
		fi
	done
fi
