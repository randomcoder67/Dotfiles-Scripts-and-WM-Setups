#!/usr/bin/env bash

STREAM_LAUNCHER_SCRIPT=$XDG_DATA_HOME/rc67/panel_scripts/streamLauncher.sh

theme=$(cat "$XDG_CONFIG_HOME/rc67/currentTheme.txt")

if [[ "$theme" == "railscasts" ]]; then
	notLiveColour="e6e1dc"
	liveColour="da4939"
	upcomingColour="a5c261"
	noInternetColour="ffc66d"
	disabledColour="9a7cff"
elif [[ "$theme" == "dracula" ]]; then
	notLiveColour="fefef8"
	liveColour="e64747"
	upcomingColour="8CFF82"
	noInternetColour="fd7fbe"
	disabledColour="9a7cff"
fi

display_type="$1"
channel_name="$2"
live_status="$3"

live_at="$4"
live_name="$5"

if [[ "$display_type" == "xfce" ]]; then
	if [[ "$live_status" == "notlive" ]]; then
		open_channel_url="$4"
		echo "<txt>  </txt><txtclick>${open_channel_url}</txtclick>"
		echo "<tool>Not Live</tool>"
	elif [[ "$live_status" == "livetwitch" ]]; then
		stream_title="$4"
		twitch_at="$5"
		echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>${STREAM_LAUNCHER_SCRIPT} Twitch \"${channel_name}\" \"${twitch_at}\"</txtclick>"
		echo "<tool>Twitch - $stream_title</tool>"
	elif [[ "$live_status" == "liveyoutube" ]]; then
		stream_title="$4"
		youtube_at="$5"
		echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>${STREAM_LAUNCHER_SCRIPT} YouTube \"${channel_name}\" \"${youtube_at}\"</txtclick>"
		echo "<tool>YouTube - $stream_title</tool>"
	elif [[ "$live_status" == "waitingyoutube" ]]; then
		echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
		echo "<tool>Waiting for ${channel_name}</tool>"
	elif [[ "$live_status" == "liveinyoutube" ]]; then
		stream_title="$4"
		live_in="$5"
		echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
		echo "<tool>Stream Schedueled at $live_in - $stream_title</tool>"
	elif [[ "$live_status" == "disabled" ]]; then
		echo "<txt><span foreground='#$disabledColour'>  </span></txt>"
		echo "<tool>Stream Checkers Disabled</tool>"
	elif [[ "$live_status" == "offline" ]]; then
		echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
		echo "<tool>No Internet Connection</tool>"
	fi
elif [[ "$display_type" == "i3" ]]; then
	prefix="${channel_name:0:1}:"
	if [[ "$live_status" == "notlive" ]]; then
		echo "${prefix}<span foreground='#efe2e0'>  </span>"
	elif [[ "$live_status" == "livetwitch" ]]; then
		echo "${prefix}<span foreground='#c25431'>  </span>"
	elif [[ "$live_status" == "liveyoutube" ]]; then
		echo "${prefix}<span foreground='#c25431'>  </span>"
	elif [[ "$live_status" == "waitingyoutube" ]]; then
		echo "${prefix}<span foreground='#bbbb88'>  </span>"
	elif [[ "$live_status" == "liveinyoutube" ]]; then
		echo "${prefix}<span foreground='#bbbb88'>  </span>"
	elif [[ "$live_status" == "disabled" ]]; then
		echo "${prefix}<span foreground='#f9d25b'>  </span>"
	elif [[ "$live_status" == "offline" ]]; then
		echo "${prefix}<span foreground='#709289'>  </span>"
	fi
elif [[ "$display_type" == "awesome" ]]; then
	if [[ "$live_status" == "notlive" ]]; then
		echo "<span foreground='#efe2e0'>  </span>"
	elif [[ "$live_status" == "livetwitch" ]]; then
		echo "<span foreground='#c25431'>  </span>"
	elif [[ "$live_status" == "liveyoutube" ]]; then
		echo "<span foreground='#c25431'>  </span>"
	elif [[ "$live_status" == "waitingyoutube" ]]; then
		echo "<span foreground='#bbbb88'>  </span>"
	elif [[ "$live_status" == "liveinyoutube" ]]; then
		echo "<span foreground='#bbbb88'>  </span>"
	elif [[ "$live_status" == "disabled" ]]; then
		echo "<span foreground='#f9d25b'>  </span>"
	elif [[ "$live_status" == "offline" ]]; then
		echo "<span foreground='#709289'>  </span>"
	fi
fi
