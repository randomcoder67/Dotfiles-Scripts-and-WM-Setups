#!/usr/bin/env bash

if i3-msg -t get_tree | grep "\"scratchpad_state\":\"fresh\""; then
	i3-msg scratchpad show
elif i3-msg -t get_tree | grep "\"scratchpad_state\":\"changed\""; then
	i3-msg scratchpad show
else
	[[ "$#" == 1 ]] || notify-send "Launching Scratchpad"
	alacritty --class terminalscratchpad -e tmux new-session -s "buffer_tmux" 'micro ~/Downloads/buffer.md; bash' & disown
fi
