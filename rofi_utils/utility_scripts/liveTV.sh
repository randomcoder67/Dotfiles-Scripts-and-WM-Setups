#!/usr/bin/env bash

tv_channels_file="$XDG_CONFIG_HOME/rc67/tvChannels.txt"

toOpen=$(cat "$tv_channels_file" | cut -d '|' -f 1 | rofi -dmenu -format "i" -kb-custom-1 "Shift+Return" -i -p "Select Stream")
[[ "$toOpen" == "" ]] && exit
toOpenA=$((toOpen+1))
toOpen=$toOpenA
name=$(sed "${toOpen}q;d" "$tv_channels_file" | cut -d '|' -f 1)
streamURL=$(sed "${toOpen}q;d" "$tv_channels_file" | cut -d '|' -f 2)
player=$(sed "${toOpen}q;d" "$tv_channels_file" | cut -d '|' -f 3)
[[ "$name" == "" ]] && exit
notify-send "Opening ${name} TV Feed in ${player}"
if [[ "$player" == "mpv" ]]; then
	mpv "${streamURL}" --title="${name}" --force-window=immediate || notify-send "Error, live feed failed to open"
elif [[ "$player" == "vlc" ]]; then
	vlc "${streamURL}" --meta-title="${name}" || notify-send "Error, live feed failed to open"
else
	$player "${streamURL}" || notify-send "Error, live feed failed to open"
fi
