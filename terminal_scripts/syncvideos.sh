#!/usr/bin/env bash

oldIFS="$IFS"
IFS=$'\n'
lines=( $(cat "$XDG_CONFIG_HOME/rc67/youtube_playlists_to_archive.csv" | tail -n +2) )
#lines=( $(cat playlists_to_sync.csv | tail -n +2) )
IFS="$oldIFS"

for l in "${lines[@]}"; do
	url=$(echo "$l" | cut -d "," -f 1)
	name=$(echo "$l" | cut -d "," -f 2)
	save_loc=$(echo "$l" | cut -d "," -f 3)
	audio_only=$(echo "$l" | cut -d "," -f 4)

	true_save_loc=${save_loc/\~/$HOME}

	[ -d "$true_save_loc" ] || mkdir -p "$true_save_loc"

	echo "Downloading any new entries to $name"
	
	if [[ "$audio_only" == "no" ]]; then
		yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -P "${true_save_loc}/" -o "%(title)s.%(ext)s" --all-subs --embed-subs --cookies-from-browser firefox --embed-chapters --embed-metadata --embed-thumbnail --external-downloader aria2c --external-downloader-args "aria2c:-x 16 -j 16 -s 16 -k 1M" --download-archive "${true_save_loc}/archive.txt" "$url"
	elif [[ "$audio_only" == "yes" ]]; then
		yt-dlp -f "bestaudio[ext=m4a]/bestaudio" -P "${true_save_loc}/" -o "%(title)s - %(channel)s.%(ext)s" --cookies-from-browser firefox --embed-chapters --embed-metadata --embed-thumbnail --download-archive "${true_save_loc}/archive.txt" "$url"
	fi
done
