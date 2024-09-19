#!/usr/bin/env bash

current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
#echo "$current_workspace"
past_workspace="1:WWW"
[ -f "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt" ] && past_workspace=$(cat "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt")

if [[ "$current_workspace" == "5:DSK" ]]; then
	i3-msg workspace "$past_workspace"
else
	echo "$current_workspace" > "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt"
	i3-msg workspace "5:DSK"
fi
