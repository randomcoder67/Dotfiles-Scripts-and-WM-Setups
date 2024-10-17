#!/usr/bin/env bash

cur_status="$(nmcli r wifi)"

if [[ "$cur_status" == "enabled" ]]; then
	nmcli r wifi off
	notify-send "Airplane Mode On"
elif [[ "$cur_status" == "disabled" ]]; then
	nmcli r wifi on
	notify-send "Airplane Mode Off"
fi
