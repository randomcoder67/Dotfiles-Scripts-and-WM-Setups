#!/usr/bin/env sh

if [[ "$1" == "--up" ]]; then
	xdotool getactivewindow windowmove --relative -- -2 -62
elif [[ "$1" == "--down" ]]; then
	xdotool getactivewindow windowmove --relative -- -2 -2
elif [[ "$1" == "--left" ]]; then
	xdotool getactivewindow windowmove --relative -- -32 -32
elif [[ "$1" == "--right" ]]; then
	xdotool getactivewindow windowmove --relative -- 28 -32
fi
