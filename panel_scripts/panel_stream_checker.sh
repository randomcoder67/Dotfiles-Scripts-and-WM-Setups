#!/usr/bin/env bash

# Panel Stream Monitor
# Usage: ./streamChecker.sh channel_name youtube_channel_@ twitch_@ theme_flag

SAVE_LOC="$XDG_CACHE_HOME/rc67/streams/panel"
[ -d "$SAVE_LOC" ] || mkdir -p "$SAVE_LOC"

FORMATTER_SCRIPT="$XDG_DATA_HOME/rc67/panel_scripts/formatter.sh"

# Constants

infoLoc="$XDG_CONFIG_HOME/rc67/panel_stream_checkers.csv"
picturesLoc="$XDG_CONFIG_HOME/rc67/panel_pictures/"

option="$1"
number="$2"
display_type="$3"

fileContents=$(cat "$infoLoc" | sed "${number}!d")

if [[ "$option" == "-c" ]]; then
	channelName=$(echo "$fileContents" | cut -d "," -f 1)
	youtubeChannelAt=$(echo "$fileContents" | cut -d "," -f 2)
	twitchAt=$(echo "$fileContents" | cut -d "," -f 3)
elif [[ "$option" == "-p" ]]; then
	picture="${picturesLoc}/pic${number}.jpg"
	channelName=$(echo "$fileContents" | cut -d "," -f 1)
	echo "<img>${picture}</img><tool>${channelName}</tool>"
	exit
fi

liveYouTube="false"
liveTwitch="false"

enabled="yes"

if [[ "$enabled" == "disabled" ]]; then
	"$FORMATTER_SCRIPT" "$display_type" "$channelName" "disabled"
	exit
fi

if [[ "$youtubeChannelAt" != "NONE" ]]; then
	# Download and check for internet
	if ! curl "https://www.youtube.com/@${youtubeChannelAt}/live" > "${SAVE_LOC}/${channelName}YouTube.html"; then
		"$FORMATTER_SCRIPT" "$display_type" "$channelName" "offline"
		exit
	# Check for live status
	elif grep -q "Pop-out chat" "${SAVE_LOC}/${channelName}YouTube.html"; then
		# Check if stream scheduled
		if grep -q "Live in" "${SAVE_LOC}/${channelName}YouTube.html" || grep "Waiting for" "${SAVE_LOC}/${channelName}YouTube.html" | grep -v -q "Internet connection"
		then
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' "${SAVE_LOC}/${channelName}YouTube.html" | cut -d "\"" -f 5)
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' "${SAVE_LOC}/${channelName}YouTube.html" | cut -d "\"" -f 9 | sed 's/&/and/g' | sed 's/\\u0026/and/g')
			"$FORMATTER_SCRIPT" "$display_type" "$channelName" "liveinyoutube" "$streamTitle" "$liveAt"
			liveYouTube="true"
		# Or waiting for streamer
		elif grep -q "Waiting for ${channelName}" "${SAVE_LOC}/${channelName}YouTube.html"; then
			"$FORMATTER_SCRIPT" "$display_type" "$channelName" "waitingyoutube"
			liveYouTube="true"
		# Otherwise they are live now
		else
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' "${SAVE_LOC}/${channelName}YouTube.html" | cut -d "\"" -f 9 | sed 's/&/and/g' | sed 's/\\u0026/and/g')
			"$FORMATTER_SCRIPT" "$display_type" "$channelName" "liveyoutube" "$streamTitle" "$youtubeChannelAt"
			liveYouTube="true"
		fi
	fi
fi

if [[ "$twitchAt" != "NONE" ]] && [[ "$liveYouTube" == "false" ]]; then
	if yt-dlp --write-info-json --skip-download "https://www.twitch.tv/${twitchAt}" -P ${SAVE_LOC} -o "${channelName}TwitchMetadata.%(ext)s"; then
		streamTitle=$(cat "${SAVE_LOC}/${channelName}TwitchMetadata.info.json" | jq -r .description | sed 's/&/and/g')
		"$FORMATTER_SCRIPT" "$display_type" "$channel_name" "livetwitch" "$streamTitle" "${twitchAt}"
		liveTwitch="true"
	fi
fi

if [[ "$liveYouTube" == "false" ]] && [[ "$liveTwitch" == "false" ]]; then
	urlOpenString="firefox"
	if [[ "$youtubeChannelAt" != "NONE" ]]; then
		urlOpenString="${urlOpenString} --new-tab 'https://www.youtube.com/@${youtubeChannelAt}'"
	fi
	if [[ "$twitchAt" != "NONE" ]]; then
		urlOpenString="${urlOpenString} --new-tab 'https://www.twitch.tv/${twitchAt}/videos?filter=archives&sort=time'"
	fi
	"$FORMATTER_SCRIPT" "$display_type" "$channel_name" "notlive" "$urlOpenString"
fi
