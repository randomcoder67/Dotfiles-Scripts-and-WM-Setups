#
# ~/.bashrc
#

PROMPT_COMMAND=
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
	source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

# Load bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi

# Normal prompt
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# Power Management Functions

#### SUBSTITUTE - POWER MANAGEMENT

# External Program Openers

# Open pdf files in Zathura
pdf () {
	for arg; do
		zathura "$arg" & disown
	done
}

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

# Open video(s) with mpv
mp () {
	/usr/bin/mpv --really-quiet --save-position-on-quit "$@" & disown
}

# Open video(s) with mpv (reverse order)
mpvr () {
	find "$(pwd)" -mindepth 1 | sort | tac > /tmp/tempPlaylist.m3u
	/usr/bin/mpv --really-quiet --save-position-on-quit /tmp/tempPlaylist.m3u & disown
}

# Open YouTube video with mpv
mp-yt () {
	/usr/bin/mpv --really-quiet --title='${media-title}' --ytdl-format='bestvideo[protocol*=m3u8][height<=2160][vcodec*=avc1]+bestaudio[protocol*=m3u8]' "$@" & disown
}

#### SUBSTITUTE - IMAGE VIEWER

# Open folder/files in Lite-XL
lt () {
	lite-xl "$@" & disown
}


# Basic Aliases/Functions

alias grep='grep -i --color=auto'
alias greps='/usr/bin/grep --color=auto'
alias grepa='grep -i -I -A 5 -B 5 --color=auto'
alias l='ls --group-directories-first --file-type -N -1 -h --color=auto'
alias ls='ls --group-directories-first --file-type -N -h --color=auto'
alias la='ls --group-directories-first --file-type -NA -1 -h --color=auto'
alias lsa='ls --group-directories-first --file-type -NA -h --color=auto'
alias ld='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ 2> /dev/null'
alias lda='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ .*/ 2> /dev/null'
alias lsd='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ 2> /dev/null'
alias lsda='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ .*/ 2> /dev/null'
alias diff='diff --color'
alias hs='history'
alias ra='ranger'
alias py='python3'
alias pyp='~/.local/share/rc67/.venv/bin/python3'
alias pipp='~/.local/share/rc67/.venv/bin/pip3'
alias nf='neofetch'
alias sq='ncdu --color dark'
alias bat='bat --theme=base16'
alias lsblk='lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS'
alias mv='mv -i'
alias cp='cp -r -i'
alias cmatrix='cmatrix -u 6'
alias duf='duf -hide special'
alias gtop='sudo intel_gpu_top'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias sb='secondbrain'
alias streams='terminalStreamChecker'
alias rm='rm-trash-cli'

function cal () {
	unbuffer cal -n 3 "$@" | sed '/^ *$/d'
}

function tmux () {
	#oldterm="$TERM"
	#export TERM="xterm-kitty"
	/usr/bin/tmux "$@"
	#export TERM="$oldterm"
}

# Git Aliases

alias gitd='git diff'
alias gitdc='git diff --word-diff-regex=.'
alias gits='git status'
alias gpl='git pull'
alias gp='git push'
alias gitl='git log --reverse'
alias giturl='git config --get remote.origin.url'

# Pacman Aliases

alias install='sudo pacman -S'
alias remove='sudo pacman -Rs'
alias update='sudo pacman -Syu'
alias search='pacman -Ss'

function pacs() {
	numberOfPackages="$(pacman -Q | wc -l)"
	echo "${numberOfPackages} packages installed"
}

# Bash/Terminal Functions

## Function to remove things which aren't useful from bash history
trim_history () {
	# Remove literal "q", "ls", "l", "lsa", "exit", "c", "cl", "cd", "rm", "x", "gits", "gitd", "gitl", "htop", "btop", "nethogs", "cava", "vis", "qalc", "history" and "hs" from bash history
	sed -i -r '/^(history|hs|qalc|vis|cava|nethogs|btop|htop|gitl|gitd|gits|x|rm|cd|c|exit|lsa|ls|l|q)$/d' ~/.bash_history
	# Remove any usage of fasd z autojump command
	sed -i '/^z .*/d' ~/.bash_history
	sed -i '/^zz .*/d' ~/.bash_history
	# Remove any usage of rm command
	sed -i '/^rm .*/d' ~/.bash_history
	sed -i '/^youtube .*/d' ~/.bash_history
	#sed -i '/^git add .*/d' ~/.bash_history
	#sed -i '/^git mv .*/d' ~/.bash_history
	#sed -i '/^stuff .*/d' ~/.bash_history
	#sed -i '/^schedule .*/d' ~/.bash_history
	#sed -i '/^log .*/d' ~/.bash_history
	#sed -i '/^money .*/d' ~/.bash_history
	#sed -i '/^git commit .*/d' ~/.bash_history
	#sed -i '/^[.]/.*/d' ~/.bash_history
	
	# Remove any usage of cd, ls and mpv when only going one folder deeper in file structure
	sed -i -r '/^(cd|ls|mpv|mpv) [^\/\>\<|:&]*\/? ?$/d' ~/.bash_history
	# Remove any usage of ms, msn, rs and pdf when not going into a different folder
	sed -i -r '/^(ms[n]?|rs|pdf) [^\/\>\<|:&]* ?$/d' ~/.bash_history
	# Remove anything in all caps, as it will basically always be a mistype
	sed -i '/^[A-Z0-9 ]*$/d' ~/.bash_history
	# Remove all duplicates, keeping most recent
	tac ~/.bash_history | awk '!x[$0]++' | tac > ~/.bash_history_no_dupes && command mv ~/.bash_history_no_dupes ~/.bash_history
	#sed --in-place 's/[[:space:]]\+$//' .bash_history && awk -i inplace '!seen[$0]++' .bash_history
}

alias c='clear'
alias q='trim_history && exit'
alias reload='. ~/.bashrc'

## Swap prompt for anonomous one and back
anonprompt () {
	if [[ "$PS1" == *"user"* ]]; then
		PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
	else
		PS1='\[\033[1;36m\]user\[\033[1;31m\]@\[\033[1;32m\]Laptop:\[\033[1;35m\]\W\[\033[1;31m\]\$\[\033[0m\] '
	fi
}

# Aliases to Specific Commands

alias x='chmod +x'
alias copy='xclip -selection c'
alias batl='find . -maxdepth 1 | sort | tail -n 1 | xargs bat --theme=base16'

## Quick preview files with bat and fasd
batf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	bat --theme=base16 "$result"
}

alias balance='aacgain -r -m 1 *.m4a'
alias vol='pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g"'
alias rmedir='find . -type d -empty -delete'
alias serial='sudo cat /sys/devices/virtual/dmi/id/product_serial'
alias pyweb='python3 -m http.server -d'
alias rss='newsboat; podboat'
alias trash-size='du ~/.local/share/Trash/files/ -s -h | cut -f 1'
alias sync='echo "Syncing"; sync; echo "Done"; lsblk'
alias batteryremaining='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "time to empty" | grep --color=no -Eo "[0-9.]{1,4} hours"'
alias lastyear='log -d $(date -d "-1 year" +"%y%m%d")'
alias fatmount='sudo mount -o rw,users,umask=000'

function archiveplaylist() {
	yt-dlp --cookies-from-browser firefox -J --flat-playlist "$1" | jq '.entries[] | [.title,.channel,.url]| @csv'
}

function sortfile () {
	[[ "${#@}" != "1" ]] && echo "Usage: sortfile filename" && return
	[ -f "${1}_sorted_temporary_file" ] && echo "Error, file with temp name already exists" && return
	sort "$1" > "${1}_sorted_temporary_file" && trash-put "$1" && mv -f "${1}_sorted_temporary_file" "$1"
}

function songs () {
	if [[ "$1" == "-e" ]]; then
		"$VISUAL" "$XDG_DATA_HOME/rc67/songs.txt"
	else
		cat "$XDG_DATA_HOME/rc67/songs.txt"
	fi
}

## Function to show time in various locations
function t () {
	MAGENTA_COLOUR='\033[0;35m\033[1m'
	RESET_COLOUR='\033[0m'
	metricTimeDays=$(metrictime -d -s)
	metricTimeMinutes=$(metrictime -m -s)
	metricTimeSeconds=$(metrictime -s -s)
	curDateZone=$(date +"%a, %b %d (%Z)")
	echo -e "${MAGENTA_COLOUR}Metric Time${RESET_COLOUR}:"
	echo "  Days:           $metricTimeDays - $curDateZone"
	echo "  Minutes:        $metricTimeMinutes - $curDateZone"
	echo "  Seconds:        $metricTimeSeconds - $curDateZone"
	echo -e "${MAGENTA_COLOUR}Normal Time${RESET_COLOUR}:"
	TZ="America/Los_Angeles" date +"  Los Angeles:    %H:%M:%S - %a, %b %d (%Z)"
	TZ="America/New_York" date +"  New York:       %H:%M:%S - %a, %b %d (%Z)"
	date -u +"  UTC:            %H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/London" date +"  London:         %H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/Paris" date +"  Paris:          %H:%M:%S - %a, %b %d (%Z)"
	TZ="Asia/Seoul" date +"  Seoul:          %H:%M:%S - %a, %b %d (%Z)"
	TZ="Australia/Sydney" date +"  Sydney:         %H:%M:%S - %a, %b %d (%Z)"
}

alias lc='ls | wc -l'
alias lca='ls -A | wc -l'


# Various Search Commands

alias his='history | grep'

## Search root directory
findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

alias findh='find ~ -iname'
alias fig='find . | grep'
alias psg='ps -aux | grep'


# yt-dlp Function

do_yt-dlp () {
	local aria_args=()
	local metadata_args=()
	local cookies_args=()
	local archive_args=()
	local other_args=()
	output_format_args=(-o "%(title)s.%(ext)s")
	format_args=()
	
	while [[ $# -gt 0 ]]; do
		case "$1" in
			--aria)
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M")
				shift
				;;
			--aria-limit)
				download_limit="3"
				num_re='^[0-9]+$'
				if [[ "$2" =~ $num_re ]]; then
					download_limit="$2"
					shift
				fi
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=${download_limit}M")
				shift
				;;
			--all-metadata)
				metadata_args+=("--embed-chapters" "--embed-thumbnail" "--embed-metadata")
				shift
				;;
			--music)
				output_format_args=(-o "%(title)s - %(channel)s - %(album)s.%(ext)s")
				format_args=(-f 140)
				shift
				;;
			--standard)
				format_args=(-f "22/bestvideo[height<=720]+bestaudio")
				shift
				;;
			--firefox-cookies)
				cookies_args=("--cookies-from-browser" "firefox")
				shift
				;;
			--archive)
				archive_args=("--download-archive" "archive.txt")
				shift
				;;
			*)
				other_args+=("$1")
				shift
				;;
		esac
	done
	
	
	local all_args=("${output_format_args[@]}" "${aria_args[@]}" "${metadata_args[@]}" "${cookies_args[@]}" "${format_args[@]}" "${archive_args[@]}" "${other_args[@]}" "$@")
	/usr/bin/yt-dlp "${all_args[@]}"
}

## Alias to allow escaping with backslash
alias yt-dlp='do_yt-dlp'

# Quick cd

alias doc='cd ~/Documents/'
alias dow='cd ~/Downloads/'
alias mus='cd ~/Music/'
alias vid='cd ~/Videos/'
alias pic='cd ~/Pictures/'
alias pro='cd ~/Programs/'
alias wor='cd ~/Work/'
alias loc='cd ~/.local/share/'
alias bin='cd ~/.local/bin/'
alias con='cd ~/.config/'
alias cur='cd ~/Music/CurrentPlaylist/'
alias dot='cd ~/Programs/dotfiles/'
alias bac='cd ~/Downloads/BackupMount/'
alias web='cd ~/Programs/website/GitHubWebsite/'
alias inst='cd "$HOME/.local/share/multimc/instances/1.20.1 Main/.minecraft"'

# Other

alias files='wc -l ~/.cache/rc67/files.txt'
alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias curloc='cat ~/.config/rc67/cur_location.csv | sed "s/|/\n/g"'
alias todo='micro ~/Documents/todo.md'
alias stonehenge='cat ~/.local/share/rc67/data/stonehenge.txt'

source "$HOME/.local/share/rc67/data/autocompletion.bash"

HISTSIZE=50000
HISTFILESIZE=50000

export HISTCONTROL=ignoreboth:erasedups
export MICRO_TRUECOLOR=1
export PASSWORD_STORE_CLIP_TIME=120

[ -f ~/Programs/localStuff/aliases.sh ] && source ~/Programs/localStuff/aliases.sh

export _FASD_NOCASE=1
eval "$(fasd --init auto)"

unalias a
unalias s
unalias sd
unalias sf
