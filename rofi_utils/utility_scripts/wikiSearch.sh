#!/usr/bin/env sh

apiAddress="$1"
pageAddress="$2"
mainPage="$3"
wikiName="$4"

openBrowser="$XDG_DATA_HOME/rc67/rofi_utility_scripts/openBrowser.sh"

searchTerm=$(rofi -dmenu -p "Enter Search Term (Blank for homepage)") # Get search term from user

[[ "$?" == "1" ]] && exit

if [[ "$searchTerm" == "" ]]; then # If blank, open main page
	"$openBrowser" "$mainPage"
else # Otherwise, use API to search
	finalSearchTerm=${searchTerm// /+} # Replaces spaces with "+" for url
	searchResults=$(curl "${apiAddress}action=query&format=json&errorformat=bc&prop=&list=search&srsearch=$finalSearchTerm")
	# Present results to user and allow them to pick desired page
	result=$(echo $searchResults | jq .query.search.[].title -r | rofi -dmenu -i -p "Choose Page")
	[[ "$?" == "1" ]] && exit
	if [[ "$result" != "" ]]; then
		urlString=${result// /_} # Replace spaces with "_" for url
		"$openBrowser" "${pageAddress}${urlString}"
	fi
fi
