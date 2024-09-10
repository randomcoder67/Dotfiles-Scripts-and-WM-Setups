#!/usr/bin/env sh

# Rofi emoji picker

cat "$XDG_DATA_HOME/rc67/data/allEmojis.txt" | rofi -dmenu -i -p "Pick Emoji" | cut -d " " -f 1 | tr -d '\n' | xclip -selection c
