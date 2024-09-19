#!/usr/bin/env bash

[ -d "$HOME/.cache/rc67" ] || mkdir "$HOME/.cache/rc67"

idFile="$HOME/.cache/rc67/volumeNotifiationId"

if [ -f "$idFile" ]; then
	oldNotificationId=$(cat "$idFile")
else
	oldNotificationId="1001"
fi

function get_icon_name() {
	if [[ "$1" == "0" ]]; then
		echo "audio-volume-muted-symbolic"	
	elif [[ "$1" -lt "30" ]]; then
		echo "audio-volume-low-symbolic"	
	elif [[ "$1" -lt "70" ]]; then
		echo "audio-volume-medium-symbolic"	
	else
		echo "audio-volume-high-symbolic"	
	fi
}

function show_notification() {
	new_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g" | sed 's/%//g')
	echo "$new_volume"
	iconName="$(get_icon_name $new_volume)"
	echo "$iconName"
	newId=$(notify-send "Volume" -p -r "$oldNotificationId" -i $iconName -h int:value:"$new_volume")
	echo "$newId" > "$idFile"
}

if [[ "$1" == "--down" ]]; then
	pactl set-sink-volume @DEFAULT_SINK@ -3%
	show_notification
elif [[ "$1" == "--up" ]]; then
	current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g" | sed 's/%//g')
	if [[ "$current_volume" -gt "97" ]]; then
		pactl set-sink-volume @DEFAULT_SINK@ 100%
	else
		pactl set-sink-volume @DEFAULT_SINK@ +3%
	fi
	show_notification
elif [[ "$1" == "--toggle-mute" ]]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	show_notification
fi


