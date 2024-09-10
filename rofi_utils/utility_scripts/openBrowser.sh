#!/usr/bin/env sh

onDesktopLoc="$XDG_DATA_HOME/rc67/rofi_utility_scripts/onDesktop.sh"
curLocationFile="$XDG_CONFIG_HOME/rc67/cur_location.csv"

url="$1"

if echo "$url" | grep -q "£GEOHASH"; then
	len=9
	if echo "$url" | grep -q "£GEOHASH:"; then
		len=$(echo "$url" | grep -o "£GEOHASH:*[0-9]*" | cut -d ":" -f 2)
	fi
	lat=$(cat "$curLocationFile" | cut -d "|" -f 1)
	lon=$(cat "$curLocationFile" | cut -d "|" -f 2)
	geohash=$(~/.local/bin/geohash "$lat" "$lon" "$len")
	url="$(echo "$url" | sed "s/£GEOHASH:*[0-9]*/"$geohash"/g")"

elif echo "$url" | grep -q "£LAT"; then
	len=4
	if echo "$url" | grep -q "£LAT:"; then
		len=$(echo "$url" | grep -o "£LAT:*[0-9]*" | cut -d ":" -f 2)
	fi
	
	lat=$(cat "$curLocationFile" | cut -d "|" -f 1)
	lon=$(cat "$curLocationFile" | cut -d "|" -f 2)
	
	len=$((len+1))
	ogLen="$len"
	if echo "$lat" | grep -q '-'; then
		len=$((len+1))
	fi
	lat=${lat:0:$len}
	
	len="$ogLen"
	if echo "$lon" | grep -q '-'; then
		len=$((len+1))
	fi
	lon=${lon:0:$len}
	
	echo $lat $lon
	url="$(echo "$url" | sed "s/£LAT:*[0-9]*/"$lat"/g")"
	url="$(echo "$url" | sed "s/£LON:*[0-9]*/"$lon"/g")"
fi

if "$onDesktopLoc" -q "$BROWSER"; then
	"$BROWSER" "$url" --new-window
else
	"$BROWSER" "$url" --new-window
fi

