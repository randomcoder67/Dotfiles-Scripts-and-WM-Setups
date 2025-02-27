#!/usr/bin/env bash

DESKTOP_WORKSPACE_NAME="8:DSK"

current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
past_workspace="1:WWW"

if [[ "$1" == "--temp-workspace" ]]; then
	TEMP_WORKSPACE_NAME="10:TMP"
	[ -f "$XDG_CACHE_HOME/rc67/i3_last_workspace_non_temp.txt" ] && past_workspace=$(cat "$XDG_CACHE_HOME/rc67/i3_last_workspace_non_temp.txt")
	if [[ "$current_workspace" == "$TEMP_WORKSPACE_NAME" ]]; then
		i3-msg workspace "$past_workspace"
	elif [[ "$current_workspace" == "$DESKTOP_WORKSPACE_NAME" ]]; then
		i3-msg workspace "$TEMP_WORKSPACE_NAME"
	else
		echo "$current_workspace" > "$XDG_CACHE_HOME/rc67/i3_last_workspace_non_temp.txt"
		i3-msg workspace "$TEMP_WORKSPACE_NAME"
	fi
	exit
fi

[ -f "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt" ] && past_workspace=$(cat "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt")

if [[ "$current_workspace" == "$DESKTOP_WORKSPACE_NAME" ]]; then
	i3-msg workspace "$past_workspace"
else
	echo "$current_workspace" > "$XDG_CACHE_HOME/rc67/i3_last_workspace.txt"
	i3-msg workspace "$DESKTOP_WORKSPACE_NAME"
fi
