## Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	if [[ "$yesOrNoShutdown" == "y" ]]; then
		tmux send-keys -t buffer_tmux.0 C-s
		tmux send-keys -t buffer_tmux.0 C-q
		tmux kill-session -t buffer_tmux
		/usr/bin/shutdown -h 0
	fi
}

## Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	if [[ "$yesOrNoReboot" == "y" ]]; then
		tmux send-keys -t buffer_tmux.0 C-s
		tmux send-keys -t buffer_tmux.0 C-q
		tmux kill-session -t buffer_tmux
		/usr/bin/systemctl reboot
	fi
}

## Hibernate to disk with confirmation
hibernate () {
	read -p "Hibernate? (y/N) " yesOrNoHibernate
	[[ "$yesOrNoHibernate" == "y" ]] && systemctl hibernate
}

## Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read -p "Hybrid-Sleep? (y/N) " yesOrNoHybridSleep
	[[ "$yesOrNoHybridSleep" == "y" ]] && systemctl hybrid-sleep
}

## Sleep with confirmation (i.e. RAM only)
qsleep () {
	read -p "Sleep? (y/N) " yesOrNoQSleep
	[[ "$yesOrNoQSleep" == "y" ]] && systemctl suspend
}

## Log Out with confirmation
log-out () {
	read -p "Log Out? (y/N) " yesOrNoLogOut
	[[ "$yesOrNoLogOut" == "y" ]] && jwm -exit
}

## Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && xdg-screensaver lock
}
