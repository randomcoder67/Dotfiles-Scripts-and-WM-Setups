# Open images in qimgv (normal)
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		qimgv . & disown
	else
		qimgv "$@" & disown
	fi
}
