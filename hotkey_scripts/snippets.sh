#!/usr/bin/env bash

# Credit for this script goes to YouTuber Functional Industries: https://www.youtube.com/watch?v=PRgIxRl67bk, although my version is modified

SNIPS_LOCATION="${XDG_DATA_HOME}/rc67/script_data/snippets"

file=$(find "$SNIPS_LOCATION" -type f -printf "%f\n" | sort | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -kb-custom-3 "Shift+Return" -dmenu -i -p "Select Snippet (Shift+Return To Type)")

status="$?"

[[ "$status" == 1 ]] && exit

# Add new snippet
if [ $status -eq 10 ]; then
	alacritty -t snippets --working-directory "$SNIPS_LOCATION"
# Remove snippet
elif [ $status -eq 11 ]; then
	yes_no=$(echo -en "No\nYes" | rofi -dmenu -p "Confirm Deletion?")
	if [[ "$yes_no" == "Yes" ]]; then
		rm "${SNIPS_LOCATION}/${file}"
	fi
# Type snippet
elif [ $status -eq 12 ]; then
	DATA=$([ -x "${SNIPS_LOCATION}/${file}" ] && bash "${SNIPS_LOCATION}/${file}" || head --bytes=-1 "${SNIPS_LOCATION}/${file}")
	printf "$DATA" | xsel -p -i
	xdotool keyup Shift_L Shift_R
	xdotool key shift+Insert
# Copy snippet
else
	DATA=$([ -x "${SNIPS_LOCATION}/${file}" ] && bash "${SNIPS_LOCATION}/${file}" || head --bytes=-1 "${SNIPS_LOCATION}/${file}")
	printf "$DATA" | xsel -b -i
	notify-send "Snippet Copied to Clipboard"
fi

