# Open images in sxiv (normal)
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		sxiv -t . & disown
	else
		sxiv -t "$@" & disown
	fi
}
