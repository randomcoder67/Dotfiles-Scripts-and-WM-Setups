#!/usr/bin/env bash

# Script to perform general setup for my dotfiles and scripts

if [[ "$1" == "--setup" ]]; then
	data_home=${XDG_DATA_HOME:-$HOME/.local/share}
	echo $data_home

	[ -d "$data_home/rc67/panel_scripts" ] || mkdir -p "$data_home/rc67/panel_scripts"
	[ -d "$data_home/rc67/hotkey_scripts" ] || mkdir -p "$data_home/rc67/hotkey_scripts"
	[ -d "$data_home/rc67/rofi_utility_scripts" ] || mkdir -p "$data_home/rc67/rofi_utility_scripts"
	[ -d "$data_home/rc67/data" ] || mkdir -p "$data_home/rc67/data"
	[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"

	cp hotkey_scripts/* "$data_home/rc67/hotkey_scripts/"
	cp panel_scripts/*.py "$data_home/rc67/panel_scripts/"
	gcc -Wall -Wextra panel_scripts/cpu.c -o panel_scripts/cpu
	mv panel_scripts/cpu "$data_home/rc67/panel_scripts/"
	cp rofi_utils/utility_scripts/*.sh "$data_home/rc67/rofi_utility_scripts/"
	go build -o rofi_utils/utility_scripts/geohash rofi_utils/utility_scripts/geohash.go
	mv rofi_utils/utility_scripts/geohash "$HOME/.local/bin"
	cp rofi_utils/rofiBookmarks.sh rofi_utils/addIconsBookmarks.sh "$data_home/rc67/hotkey_scripts/"

	cd terminal_scripts; make full; cd ..
	cd rofi_utils/launcher; make full; cd ../..
	cp -r other_files/allEmojis.txt "$data_home/rc67/data/"
	cp -r other_files/autocompletion.bash "$data_home/rc67/data/"
	cp -r other_files/stonehenge.txt "$data_home/rc67/data/"
	# Copy example configs only if none existing?
	cd "$XDG_DATA_HOME"; python -m venv .venv; cd
elif [[ "$1" == "--install" ]]; then
	if [[ "$2" == "" ]]; then
		echo "Ensuring system is up to date"
		sudo pacman -Syu

		echo "Installing needed packages"
		sudo pacman -S \
			papirus-icon-theme ttf-droid ttf-roboto ttf-roboto-mono noto-fonts noto-fonts-emoji noto-fonts-extra noto-fonts-cjk \
			mousepad firefox imagemagick mpv \
			songrec gimp alacritty cool-retro-term zathura zathura-pdf-mupdf zathura-ps pinta \
			bc btop htop ncdu intel-gpu-tools pulsemixer nethogs vi micro tmux newsboat libqalculate \
			unzip man man-pages bat duf ffmpeg mediainfo yt-dlp hyperfine glow jq neofetch tokei dust zip pass rsync perl-rename moreutils zbar speedtest-cli aria2 \
			python-pillow python-mutagen python-requests python-pandas python-pipx python-cairo python-beautifulsoup4 python-lxml \
			go make meson ninja gcc base-devel sassc strace valgrind \
			libxtst libvoikko aspell-en hspell nuspell hunspell libnotify \
			xclip xdotool wmctrl xcolor \
			socat rofi xdg-utils trash-cli pkg-config progress expect fuse gnome-keyring words net-tools perl-image-exiftool bash-completion smartmontools webp-pixbuf-loader \
			pavucontrol alsa-firmware sof-firmware intel-media-driver pipewire pipewire-pulse pipewire-alsa \
			vlc cmake imlib2 stress
	elif [[ "$2" == "xfce" ]]; then
		sudo pacman -S xfce4-genmon-plugin xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter ristretto thunar-archive-plugin network-manager-applet
	elif [[ "$2" == "i3" ]]; then
		sudo pacman -S dunst i3 feh
	fi
elif [[ "$1" == "--git-repos" ]]; then
	# rust org utils
	git clone https://github.com/randomcoder67/Organisation-Utils
	cd Organisation-Utils
	make
	make install # Installs locally
	
	# consistent syntax highlighting
	
	# gotube
	
	# ksuperkey
	git clone https://github.com/hanschen/ksuperkey
	cd ksuperkek
	make
	sudo make install
fi





