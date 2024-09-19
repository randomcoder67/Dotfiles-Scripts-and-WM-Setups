#!/usr/bin/env bash

current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

main_data=$(i3-msg -t get_tree | jq -r --arg curworkspace "$current_workspace" '.nodes[] | .nodes[] | .nodes[] | select(.name==$curworkspace) | .nodes[] | .nodes[]')

if echo "$main_data" | jq -r '.window_properties | .class' | grep -q firefox; then
	firefox_window_id=$(echo "$main_data" | jq -r 'select(.window_properties.class=="firefox") | .id')
	i3-msg [con_id=\""$firefox_window_id"\"] focus
	echo $firefox_window_id
	#sleep 0.1
	#echo "$main_data" | jq 'select(.window_properties.class=="firefox")'
	firefox --new-tab --url about:newtab
else
	firefox
fi
