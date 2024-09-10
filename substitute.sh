#!/usr/bin/env bash

filename="$2"
repo_folder_name="$3"

username="$(whoami)"

check_if_substitution_exists () {
	fake_dirname="$1"
	sub_name="$2"
	to_test="$3"
	
	oldIFS="$IFS"
	IFS=$'\n'
	
	files=( $(find "$fake_dirname" -maxdepth 1 -type f | grep -E "/${sub_name}_") )
	IFS="$oldIFS"
	for f in "${files[@]}"; do
		if diff "$f" - <<< "$to_test" > /dev/null; then
			echo yes
			return
		fi
	done
	echo no
	return
}

# Saving a real file into the repo involves a few steps
# 	1. Find any substitutions
#	2. Check if those substitutions are already saved
#		2.1. If not, ask for new name and save
#	3. Remove the substitution, leaving only the name, and save file
if [[ "$1" == "--save" ]]; then
	# Find start and end of substitutions
	starts=( $(cat "$filename" | grep "#### SUBSTITUTE" -n | cut -d ":" -f 1) )
	ends=( $(cat "$filename" | grep "#### END SUBSTITUTE" -n | cut -d ":" -f 1) )
	
	# Forming sed command to remove all substitutions
	sed_command=""
	
	# Iterate through substitutions
	for i in $(seq 1 "${#starts[@]}"); do
		index=$((i-1))
		# Add onto sed command
		sed_command="${sed_command}$((${starts[index]}+1)),${ends[index]}d;"
		
		# Get the substitution name and content
		substitution_name=$(sed "${starts[index]}!d" "$filename" | sed 's/#### SUBSTITUTE - //g')
		substitution_content=$(sed -n "$((${starts[index]}+1)),$((${ends[index]}-1))p" "$filename" | sed "s/"$username"/USER_USERNAME/g")
		
		# The input will be the real full path, we want the path in the repository (i.e. "fake path")
		fake_filename="${filename/$HOME/$repo_folder_name}"
		fake_dirname=$(dirname "$fake_filename")
		file_basename=$(basename "$fake_filename")
		
		# Check if the substitution exists
		if [[ $(check_if_substitution_exists "$fake_dirname" "$substitution_name" "$substitution_content") == "no" ]]; then
			# If not, add it with new user-specified name
			echo "New substitution for ${substitution_name} detected"
			
			# Make sure the substitution name is not already used
			while true; do
				read -p "Enter name for new substitution: " new_sub_name
				if ! find "$fake_dirname" -maxdepth 1 -type f | grep -E "/${substitution_name}_SUBSTITUTION_${new_sub_name}_${file_basename}"; then
					break
				fi
				echo "Error, sub name already exists"
			done
			
			echo NEW: "$fake_dirname"/"${substitution_name}_SUBSTITUTION_${new_sub_name}_${file_basename}"
			
			echo "$substitution_content" > "$fake_dirname"/"${substitution_name}_SUBSTITUTION_${new_sub_name}_${file_basename}"
		fi
	done

	sed -e "$sed_command" "$filename" > "$fake_dirname"/"$file_basename"
elif [[ "$1" == "--make" ]]; then
	destination="$4"
	
	sub_points=( $(cat "$filename" | grep "#### SUBSTITUTE" -n | cut -d ":" -f 1) )
	
	cp "$filename" /tmp/temp_dotfiles_sub
	# Iterate through sub_points
	for sub_point in "${sub_points[@]}"; do
		# Get name
		substitution_name=$(sed "${sub_point}!d" "$filename" | sed 's/#### SUBSTITUTE - //g')
		
		# Get options from name
		fake_dirname=$(dirname "$filename")
		oldIFS="$IFS"
		IFS=$'\n'
		opts=( $(find "$fake_dirname" -maxdepth 1 -type f | sort | grep -E "/${substitution_name}_") )
		IFS="$oldIFS"
		
		# List options to user
		echo "Select option for substitution: ${substitution_name}, for file: ${filename/$repo_folder_name/\~}"
		i=1
		for opt in "${opts[@]}"; do
			opt=${opt##*SUBSTITUTION_}
			opt=${opt%_*}
			echo "${i}: $opt"
			i=$((i+1))
		done
		read -p "Option: " user_choice
		
		# Copy file to temp location
		
		
		# Perform actual substitution
		user_choice=$((user_choice-1))
		
		text="#### SUBSTITUTE - ${substitution_name}"$'\n'$(cat "${opts[$user_choice]}")$'\n'"#### END SUBSTITUTE"
		./change_text.sh "$(sed "${sub_point}!d" "$filename")" "$text"
		# How to handle multiple substitutions?
		
		sed "s/USER_USERNAME/"$username"/g" /tmp/temp_dotfiles_sub > "$destination"
	done
	command rm /tmp/temp_dotfiles_sub
fi
