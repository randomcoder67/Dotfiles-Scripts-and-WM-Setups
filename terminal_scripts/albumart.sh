#!/usr/bin/env bash

# Makes collage of all album art in directory

TEMP_DIR="$XDG_CACHE_HOME/rc67/album_art/"

[ -d "$TEMP_DIR" ] || mkdir -p "$TEMP_DIR"

IFS=$'\n'
files=( $(find "$HOME/Music/CurrentPlaylist" -mindepth 1 | grep -vP "^.$") ) # Get files excluding useless stuff

[ -d "${TEMP_DIR}/art" ] && rm -rf "$TEMP_DIR"/art

mkdir -p "${TEMP_DIR}art/art2" # Make directories

echo "Extracting album art"
for i in ${!files[@]}; do # Extract album art
	ffmpeg -i "${files[$i]}" -an -c:v copy "${TEMP_DIR}art/$i.jpg" 2>/dev/null >> /dev/null
done

if [[ $1 == "-d" ]]; then # Checking for duplicates
	echo "Removing duplicates from list"
	declare -A filesChecking
	for i in ${!files[@]}; do
		hash=$(sha256sum "${TEMP_DIR}art/$i.jpg" | cut -d " " -f1)
		filesChecking["$hash"]="${TEMP_DIR}art/$i"
	done
fi

#for x in "${!filesChecking[@]}"; do printf "[%q]=%q\n" "$x" "${filesChecking[$x]}" ; done

echo "Converting files"
if [[ $1 == "-d" ]]; then
	for x in "${!filesChecking[@]}"; do
		magick "${filesChecking[$x]}".jpg -resize 1400x1400 "${TEMP_DIR}art/art2/$(echo ${filesChecking[$x]} | cut -d "/" -f 8)".jpg
	done
else
	magick "${TEMP_DIR}"art/*.jpg -resize 1400x1400 "${TEMP_DIR}"art/art2/*.jpg
fi

echo "Creating montage"
montage -tile 0x0 -geometry +0+0 "${TEMP_DIR}"art/art2/*.jpg "${TEMP_DIR}"art/art2/output.jpg
echo "Displaying montage"
ristretto "${TEMP_DIR}"art/art2/output.jpg
echo "Cleaning up"
rm -rf "$TEMP_DIR"/art
