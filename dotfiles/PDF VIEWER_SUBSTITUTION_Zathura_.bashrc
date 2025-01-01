# Open pdf files in Zathura
pdf () {
	for arg; do
		zathura "$arg" & disown
	done
}
