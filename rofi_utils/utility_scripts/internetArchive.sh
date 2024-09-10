#!/usr/bin/env sh

openBrowser="$XDG_DATA_HOME/rc67/rofi_utility_scripts/openBrowser.sh"

url=$(rofi -dmenu -p "Enter URL to find archives of")
[[ "$url" == "" ]] && exit
"$openBrowser" "https://web.archive.org/web/*/$url"
