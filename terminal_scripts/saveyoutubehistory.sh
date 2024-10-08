#!/usr/bin/env bash

# Script to get my YouTube History and save it all to a file (per week)

dirName="$XDG_DATA_HOME/rc67/youtubeHistory"

[ -d "$dirName" ] || mkdir "$dirName"
yearWeek=$(date +"%y%m")
fileName="${yearWeek}.csv"

if [[ "$1" == "-s" ]]; then
	grep --color=auto -ir "$2" "$dirName"
	exit
fi

wc -l "$HOME/.bash_history"
read -p "Backup Bash history? (y/N): " doBashHistoryBackup
if [[ "$doBashHistoryBackup" == "y" ]] || [[ "$doBashHistoryBackup" == "Y" ]]; then
	cp "$HOME/.bash_history" "$HOME/Downloads/.bash_history_backup"
	echo "Bash history backed up to ~/Downloads"
fi

latestFile=$(ls "$dirName" | sort | tail -n 1)
lastRanString=$(stat "${dirName}/${latestFile}" | grep "Change" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}")
lastRan=$(date -d "$lastRanString" +"%s")
currentTime=$(date +"%s")

difference=$((currentTime-lastRan))
numEntriesToGetB=$((difference/864))
numEntriesToGetA=$((numEntriesToGetB*10))
numEntriesToGet=$((numEntriesToGetA+10))
echo "Saving $numEntriesToGet most recent entries to YouTube history"

output=$(yt-dlp --cookies-from-browser firefox --flat-playlist -J --playlist-end "$numEntriesToGet" "https://www.youtube.com/feed/history")
[[ "$?" == "1" ]] && exit

echo "$output" | jq '.entries[] | [.title,.channel,.url] | @csv' | tac >> "${dirName}/${fileName}" 

cat -n "${dirName}/${fileName}" | sort -uk2 | sort -n | cut -f2- > "/tmp/youtubeHistoryTemp.csv"
mv "/tmp/youtubeHistoryTemp.csv" "${dirName}/${fileName}"

echo "Reindexing Background Noise Playlist"
backgroundnoise --update

# Ensure all videos in certain playlist downloaded
syncvideos
