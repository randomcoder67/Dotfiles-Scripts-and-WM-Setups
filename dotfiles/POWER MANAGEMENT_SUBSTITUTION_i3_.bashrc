## Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	[[ "$yesOrNoShutdown" == "y" ]] && /usr/bin/shutdown -h 0
}

## Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	[[ "$yesOrNoReboot" == "y" ]] && systemctl reboot
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
	[[ "$yesOrNoLogOut" == "y" ]] && i3-msg exit
}

## Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && i3lock -i ~/Pictures/nasa/auroraIdaho.png
}
