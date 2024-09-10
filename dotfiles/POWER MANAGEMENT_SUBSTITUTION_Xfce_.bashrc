## Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	[[ "$yesOrNoShutdown" == "y" ]] && xfce4-session-logout -h
}

## Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	[[ "$yesOrNoReboot" == "y" ]] && xfce4-session-logout -r
}

## Hibernate to disk with confirmation
hibernate () {
	read -p "Hibernate? (y/N) " yesOrNoHibernate
	[[ "$yesOrNoHibernate" == "y" ]] && xfce4-session-logout -i
}

## Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read -p "Hybrid-Sleep? (y/N) " yesOrNoHybridSleep
	[[ "$yesOrNoHybridSleep" == "y" ]] && xfce4-session-logout -b
}

## Sleep with confirmation (i.e. RAM only)
qsleep () {
	read -p "Sleep? (y/N) " yesOrNoQSleep
	[[ "$yesOrNoQSleep" == "y" ]] && xfce4-session-logout -s
}

## Log Out with confirmation
log-out () {
	read -p "Log Out? (y/N) " yesOrNoLogOut
	[[ "$yesOrNoLogOut" == "y" ]] && xfce4-session-logout -l
}

## Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && xfce4-screensaver-command -l
}
