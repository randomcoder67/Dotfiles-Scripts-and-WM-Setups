#!/usr/bin/env bash

# Script to present a Rofi window to the user and allow them to select a bookmark to copy or type

# Present the Rofi window to user, get the selected item and the return status (used to know which keys were pressed)

[ -f "$XDG_CACHE_HOME/rc67/bookmarksIcons.sh" ] || "$XDG_DATA_HOME/rc67/hotkey_scripts/addIconsBookmarks.sh"

index=$("$XDG_CACHE_HOME/rc67/bookmarksIcons.sh" | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -kb-custom-3 "Shift+Return" -dmenu -show-icons -i -format "d" -p "Bookmarks")
status=$?

openFirefox() {
	url="$1"
	if "$XDG_DATA_HOME/rc67/rofi_utility_scripts/onDesktop.sh" -q "firefox"; then
		firefox "$url"
	else
		firefox --new-window "$url"
	fi
}

[[ "$status" == 1 ]] && exit

# status=10 means the user selected to add a bookmark
if [ $status -eq 10 ]; then
	# Get new bookmark to add
	itemToAdd=$(rofi -dmenu -p "Enter New Bookmark")
	[[ "$itemToAdd" == "" ]] && exit
	# Get alias for bookmark (will be blank if no alias is needed)
	itemAlias=$(rofi -dmenu -p "Enter Alias (Leave blank for no alias)")
	# Add bookmark with alias to file (if no alias specified, the bookmark and alias are the same
	if [[ "$itemAlias" == "" ]]; then
		echo "$itemToAdd""DELIM""$itemToAdd" >> "$XDG_DATA_HOME/rc67/script_data/bookmarks.txt"
	else
		echo "$itemAlias""DELIM""$itemToAdd" >> "$XDG_DATA_HOME/rc67/script_data/bookmarks.txt"
	fi
	"$XDG_DATA_HOME/rc67/hotkey_scripts/addIconsBookmarks.sh"
# status=11 means the user selected to remove a bookmark
elif [ $status -eq 11 ]; then
	# Get line number of match and remove it
	sed -i "${index}d" "$XDG_DATA_HOME/rc67/script_data/bookmarks.txt"
	"$XDG_DATA_HOME/rc67/hotkey_scripts/addIconsBookmarks.sh"
# status=12 means the user selected to open a bookmark in Firefox if possible
elif [ $status -eq 12 ]; then
	# keyup Shift as the shortcut is Shift+Return, this prevents the bookmark being typed as capital letters
	xdotool keyup Shift
	# Get bookmark, remove alias and check if url
	toOpen=$(sed "${index}q;d" "$XDG_DATA_HOME/rc67/script_data/bookmarks.txt" | awk -F 'DELIM' '{print $2}' | tr -d '\n')
	if echo "$toOpen" | grep -q -E 'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'; then # If so, open it
		openFirefox "$toOpen"
	else
		notify-send "Not a URL"
	fi
# Otherwise the program returns with default status, meaning the user has selected to copy a bookmark
else
	# Get bookmark, remove alias and copy to clipboard
	sed "${index}q;d" "$XDG_DATA_HOME/rc67/script_data/bookmarks.txt" | awk -F 'DELIM' '{print $2}' | tr -d '\n' | xclip -selection c
fi
