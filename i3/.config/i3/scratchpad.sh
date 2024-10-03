#!/usr/bin/env bash

if i3-msg -t get_tree | grep "\"scratchpad_state\":\"fresh\""; then
	i3-msg scratchpad show
else
	notify-send "Launching Scratchpad"
	alacritty --class terminalscratchpad -e tmux new-session 'micro ~/Downloads/buffer.md; bash' & disown
fi
