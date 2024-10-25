#!/usr/bin/env bash

below_10="no"
below_5="no"

while true; do
	current_battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | tr -s " " | cut -d " " -f 3 | sed 's/%//g')
	echo "$current_battery"
	if [ "$current_battery" -lt 11 ] && [[ "$below_10" == "no" ]]; then
		below_10="yes"
		below_5="no"
		notify-send "Battery Warning" "10% Battery"
	elif [ "$current_battery" -lt 6 ] && [[ "$below_5" == "no" ]]; then
		below_5="yes"
		notify-send "Battery Alert" "5% Battery"
		user_choice=$(timeout 20 bash -c 'echo -en "Cancel\nHibernate\n" | rofi -dmenu -i -p "Select Action (timeout 20s)"')
		if [[ "$?" == "124" ]] || [[ "$user_choice" == "Hibernate" ]]; then
			notify-send "Battery Alert" "Hibernating"
			systemctl hibernate
		fi
	elif [ "$current_battery" -gt 10 ]; then
		below_10="no"
		below_5="no"
	fi
	sleep 10
done
