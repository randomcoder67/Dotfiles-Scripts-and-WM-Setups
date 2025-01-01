#!/usr/bin/env bash

function get_duration () {
	directory="$1"
	recursive="$2"
	arg1=""
	arg2=""
	if [[ "$recursive" == "false" ]]; then
		arg1="-maxdepth"
		arg2="1"
	fi
	
	duration=$(find "$directory" $arg1 $arg2 | grep -E 'mp3|mp4|m4a|mkv|webm|wav|mov|avi' | xargs -d '\n' mediainfo --Inform="General;%Duration%\n" | awk '{sum+=$1} END {print sum/1000}')
	
	echo "$duration" | awk '{
		hours = int($1 / 3600);
		minutes = int(($1 % 3600) / 60);
		seconds = $1 % 60;
		printf "%d Hours, %d Minutes, %d Seconds\n", hours, minutes, seconds;
	}'
}

directory="$1"

# Non recursive total
if [[ "$#" == "1" ]]; then
	if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "help" ]]; then
		echo "Usage: media-file-duration folder [-r/-i]"
		echo "  -r: recursive"
		echo "  -i: individual file durations"
		exit
	fi
	result="$(get_duration "$directory" "false")" 
	echo "$result"
# Recursive total
elif [[ "$2" == "-r" ]]; then
	result="$(get_duration "$directory" "true")" 
	echo "$result"
# Non recursive individual
elif [[ "$2" == "-i" ]]; then
	oldIFS="$IFS"
	IFS=$'\n'
	files=( $(find "$directory" -maxdepth 1 | grep -E 'mp3|mp4|m4a|mkv|webm|wav|mov|avi') )
	IFS="$oldIFS"
	
	for file in "${files[@]}"; do
		duration=$(mediainfo --Inform="General;%Duration%" "$file" | awk '{print $1/1000}')
		file_name="$(basename "$file")"
		echo -n "${file_name}: "
		echo "$duration" | awk '{
			hours = int($1 / 3600);
			minutes = int(($1 % 3600) / 60);
			seconds = $1 % 60;
			printf "\t%d:%d:%d\n", hours, minutes, seconds;
		}'
	done
fi

#for file in *; do   echo -n $(ffprobe "$file" 2>&1 | grep 'Duration' | cut -d',' -f1 | cut -d' ' -f4 | cut -d'.' -f1);   echo " $file"; done
# find . | grep -E 'mp4|webm|m4a|mp3' | xargs -d '\n' exiftool -m -n -q -p '${Duration;our $sum;$_=ConvertDuration($sum+=$_)}'  | tail -n1
# exiftool -m -n -q -p '${Duration;our $sum;$_=ConvertDuration($sum+=$_)}' ./*.mp4 | tail -n1
