#!/usr/bin/env bash

filename=$(basename -- "$fullfile")
extension="${filename##*.}"
filename="${filename%.*}"

TEXT_EDITOR="${VISUAL:-${EDITOR}}"

STORE_DIR="$HOME/Documents/SecondBrain"

if [[ "$1" == "-o" ]]; then
	STORE_DIR="${STORE_DIR}/NotCurrent"
fi

choice=$(find "$STORE_DIR/"*".md" -maxdepth 1 -type f -printf "%f\n" | sed 's/[.]md//g' | sort | fzf --expect=ctrl-w,ctrl-a)

[[ "$?" != "0" ]] && exit

if [[ "$choice" == "ctrl-a"* ]]; then
	read -p "Enter name: " newName
	touch "${STORE_DIR}/${newName}.md"
	"$TEXT_EDITOR" "${STORE_DIR}/${newName}.md"
elif [[ "$choice" == "ctrl-w"* ]]; then
	file=$(echo "$choice" | sed 's/ctrl-w//g' | tr -d "\n").md
	echo "Are you sure you want to delete ${file}?"
	read -p "Type DELETE to delete: " toDelete
	[[ "$toDelete" == "DELETE" ]] && trash-put "${STORE_DIR}/${file}"
else
	file=$(echo "$choice" | tr -d "\n").md
	"$TEXT_EDITOR" "${STORE_DIR}/${file}"
fi
