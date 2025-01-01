# Open pdf files in Evince
pdf () {
	for arg; do
		evince "$arg" & disown
	done
}
