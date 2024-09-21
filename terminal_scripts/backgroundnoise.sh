#!/usr/bin/env bash

socketName=/tmp/mpv.playlist
PLAYLIST_URL="$(cat ~/.config/rc67/background_noise_playlist.txt)"
SAVE_FILE_LOC="$XDG_CACHE_HOME/rc67/background_noise_playlist.txt"

[ -d "$XDG_CACHE_HOME/rc67" ] || mkdir -p "$XDG_CACHE_HOME/rc67"

if [[ "$1" == "--update" ]]; then
	yt-dlp --cookies-from-browser firefox --flat-playlist -J "$PLAYLIST_URL" | jq '.entries[] | [.title,.url]' > "$SAVE_FILE_LOC"
elif [[ "$1" == "--play" ]]; then
	user_choice=$(cat "$SAVE_FILE_LOC" | jq -r '.[0]' | rofi -dmenu -i -format d -p "Select Background Noise to Play")
	[[ "$user_choice" == "" ]] && exit
	url=$(cat "$SAVE_FILE_LOC" | jq -r '.[1]' | sed -n "${user_choice}p")
	mpv --ytdl-format="best" --x11-name="otherfloating" --force-window=immediate --input-ipc-server="$socketName" "$url"
fi
