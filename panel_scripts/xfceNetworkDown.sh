#!/usr/bin/env bash

# Panel network down monitor 

[ -d "$HOME/.cache/rc67" ] || mkdir "$HOME/.cache/rc67"

# Set filename
filename="$HOME/.cache/rc67/networkDown.txt"

# wlan0 may need to be changed to your wireless adapter name
currentBytes=$(cat /sys/class/net/wlp6s0/statistics/rx_bytes)
previousBytes=$(cat "$filename")
echo "$currentBytes" > $filename

lastTwoSecs=" "

# Do calculation, ensuring final value only has 3 digits so width is maintained
if (( $(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2) ; printf"%d", final }') > 19990000 )); then
	lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1048576 ; printf"<txt>%0.1f MiB/s </txt>", final }')
else
	lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1048576 ; printf"<txt>%0.2f MiB/s </txt>", final }')
fi

echo "$lastTwoSecs<txtclick>alacritty -e nethogs</txtclick>"
echo "<tool>NetHogs</tool>"
