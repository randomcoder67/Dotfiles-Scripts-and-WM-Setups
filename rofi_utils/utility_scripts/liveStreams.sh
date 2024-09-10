#!/usr/bin/env bash

openBrowser="$XDG_DATA_HOME/rc67/rofi_utility_scripts/openBrowser.sh"

# Read in list of streamers
oldIFS="$IFS"
IFS=$'\n'
streamers=( $(cat "$XDG_CONFIG_HOME/rc67/streamers.txt") )
IFS="$oldIFS"
numStreamers=$((${#streamers[@]}/3))

# Generate rofi string and list of options
toRun=()
toOffer=""
for i in $(seq 0 $((numStreamers-1))); do
	offset=$((i*3))
	channelName="${streamers[$offset]}"
	youtubeChannelAt="${streamers[$((offset+1))]}"
	twitchAt="${streamers[$((offset+2))]}"
	
	if [[ "$youtubeChannelAt" != "NONE" ]]; then
		toRun+=("YouTube")
		toRun+=("${channelName}")
		toRun+=("${youtubeChannelAt}")
		toOffer="${toOffer}${channelName} (YouTube)"$'\n'
	fi
	if [[ "$twitchAt" != "NONE" ]]; then
		toRun+=("Twitch")
		toRun+=("${channelName}")
		toRun+=("${twitchAt}")
		toOffer="${toOffer}${channelName} (Twitch)"$'\n'
	fi
done

# Get choice from user
choiceNum=$(echo "$toOffer" | rofi -dmenu -format "i" -kb-custom-1 "Shift+Return" -i -p "Select Stream")
status="$?"
[[ "$choiceNum" == "-1" ]] && exit
[[ "$status" == 1 ]] && exit
# Get offset and paramaters for streamLauncher.sh
offset=$((3*choiceNum))
platform="${toRun[$offset]}"
channelName="${toRun[$((offset+1))]}"
channelAt="${toRun[$((offset+2))]}"
# Launch Stream
if [[ "$status" == 0 ]]; then
	"$XDG_DATA_HOME/rc67/panel_scripts/streamLauncher.sh" "$platform" "$channelName" "$channelAt"
elif [[ "$status" == 10 ]]; then
	if [[ "$platform" == "Twitch" ]]; then
		"$openBrowser" "https://www.twitch.tv/${channelAt}"
	elif [[ "$platform" == "YouTube" ]]; then
		"$openBrowser" "https://www.youtube.com/@${channelAt}/live"
	fi
fi
