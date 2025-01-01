# Open images in sxiv
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		sxiv -t . & disown
	else
		sxiv -t "$@" & disown
	fi
}
