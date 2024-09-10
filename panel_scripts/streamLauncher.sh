#!/usr/bin/env bash

# Program to open livestreams in mpv and give appropriate error messages if they fail to open

platform="$1"
channelName="$2"
channelAt="$3"

if [[ "$platform" == "YouTube" ]]; then
	notify-send "Opening ${channelName} YouTube Stream"
	mpv --force-window=immediate --no-resume-playback --ytdl-format='best/bestvideo[height<=1080]+bestaudio' --title="${channelName} - YouTube" "https://www.youtube.com/@${channelAt}/live" || notify-send "Error, stream failed to open"
elif [[ "$platform" == "Twitch" ]]; then
	notify-send "Opening ${channelName} Twitch Stream"
	mpv --force-window=immediate --no-resume-playback --ytdl-format=best --title="${channelName} - Twitch" "https://www.twitch.tv/${channelAt}" || notify-send "Error, stream failed to open"
fi
