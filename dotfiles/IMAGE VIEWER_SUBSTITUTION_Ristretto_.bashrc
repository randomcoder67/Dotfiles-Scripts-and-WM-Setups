# Open images in Ristretto (normal)
rs () {
	USER_USERNAME
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		ristretto . & disown
	else
		ristretto "$@" & disown
	fi
}
