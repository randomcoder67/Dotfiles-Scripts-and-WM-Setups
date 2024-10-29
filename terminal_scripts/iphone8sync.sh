#!/usr/bin/env bash

if ! lsusb | grep -q Apple; then
	echo "Plug in iPhone 8"
	exit
fi

idevicepair validate
idevicepair pair

[[ "$?" == "0" ]] || exit

ifuse --documents com.foobar2000.mobile "$HOME/Downloads/USBDrive"

rsync -vr --update --delete --modify-window=1 --info=progress2 --exclude="*.fbskin" ~/Music/CurrentPlaylist/ "$HOME/Downloads/USBDrive/"

fusermount -u "$HOME/Downloads/USBDrive"

idevicepair unpair
