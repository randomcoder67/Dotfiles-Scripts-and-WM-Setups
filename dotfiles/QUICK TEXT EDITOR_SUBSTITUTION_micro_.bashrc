# Open text files in micro
function m () {
	file="$(find ~/* | grep -E '.py$|.go$|.txt$|.md$|.java$|.js$|.html$|.css$|.c$|.cc$|.conf$|.lua$|.rs$|.sh$|.bash$|.csv$' | sed 's|'"$HOME"'|~|g' | fzf)"
	[[ "$file" == "" ]] && return
	micro "$file"
}
