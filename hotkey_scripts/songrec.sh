#!/usr/bin/env bash

# Script to identify a song and save to a file with timestamp 

notify-send -t 9000 "Listening to audio"
# Listen for song with songrec, timeout of 10s incase the song can't be recognised
song=""
if pactl list sinks | grep -q "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink.monitor"; then
	song=$(timeout 10s songrec recognize -d "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink.monitor")
else
	song=$(timeout 10s songrec recognize -d "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink.monitor")
fi

if ! [[ "$song" == "" ]]; then
	notify-send -t 9000 "$song"
	time=$(date +"%y%m%d %H:%M")
	# Added to file with timestamp
	echo "$time $song" >> "$XDG_DATA_HOME/rc67/songs.txt"
else
	notify-send -t 9000 "Failed to identify song"
fi
