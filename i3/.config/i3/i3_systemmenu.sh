#!/usr/bin/env bash

action=$(echo -en "Lock\nLog Out\nQuick Sleep\nHybrid Sleep\nHibernate\nShutdown\nReboot\nArch Terminal\n" | rofi -dmenu -i -p "Select Action")
[[ "$?" == "0" ]] || exit

confirm=$(echo -en "No\nYes\n" | rofi -dmenu -i -p "Confirm Action: ${action}")

[[ "$confirm" == "Yes" ]] || exit

if [[ "$action" == "Lock" ]]; then
	i3lock -i ~/Pictures/nasa/auroraIdaho.png
elif [[ "$action" == "Log Out" ]]; then
	i3-msg exit
elif [[ "$action" == "Quick Sleep" ]]; then
	systemctl suspend
elif [[ "$action" == "Hybrid Sleep" ]]; then
	systemctl hybrid-sleep
elif [[ "$action" == "Hibernate" ]]; then
	systemctl hibernate
elif [[ "$action" == "Shutdown" ]]; then
	tmux send-keys -t buffer_tmux.0 C-s
	tmux send-keys -t buffer_tmux.0 C-q
	tmux kill-session -t buffer_tmux
	/usr/bin/shutdown -h 0
elif [[ "$action" == "Reboot" ]]; then
	tmux send-keys -t buffer_tmux.0 C-s
	tmux send-keys -t buffer_tmux.0 C-q
	tmux kill-session -t buffer_tmux
	systemctl reboot
elif [[ "$action" == "Arch Terminal" ]]; then
	#sudo chvt 2
	notify-send "Do Manually (Ctrl + Alt + F2)"
fi
