#!/usr/bin/env bash

if i3-msg -t get_tree | grep "\"scratchpad_state\":\"fresh\""; then
	i3-msg scratchpad show
elif i3-msg -t get_tree | grep "\"scratchpad_state\":\"changed\""; then
	i3-msg scratchpad show
else
	[[ "$#" == 1 ]] || notify-send "Launching Scratchpad"
	tmux new-session -d -s "buffer_tmux" 'micro ~/Downloads/buffer.md; bash'
	alacritty --class terminalscratchpad -t buffer -e tmux attach -t "buffer_tmux" & disown
fi
