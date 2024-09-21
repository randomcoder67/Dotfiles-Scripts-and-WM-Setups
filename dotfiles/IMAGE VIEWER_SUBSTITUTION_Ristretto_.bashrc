# Open images in Ristretto (normal)
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		ristretto . & disown
	else
		ristretto "$@" & disown
	fi
}
