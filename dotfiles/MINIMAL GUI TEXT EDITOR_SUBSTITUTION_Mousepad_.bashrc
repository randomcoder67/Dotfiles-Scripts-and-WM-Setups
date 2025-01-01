# Open files with Mousepad
ms () {
	for arg; do
		mousepad "$arg" & disown
	done
}

# Open files with Mousepad in a new window
msn () {
	mousepad -o window & disown
	sleep 0.2
	for arg; do
		mousepad "$arg" & disown
	done
}
