#!/usr/bin/env sh

theme=$(cat "$XDG_CONFIG_HOME/rc67/currentTheme.txt")

if [[ "$theme" == "jmbi" ]]; then
	errorColour="709289"
	networkDownColour="709289"
	cpuUsageColour="709289"
	uptimeColour="f9d25b"
elif [[ "$theme" == "doom one" ]]; then
	errorColour="51afef"
	networkDownColour="51afef"
	cpuUsageColour="51afef"
	uptimeColour="ffd700"
fi

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

echo "<span foreground='#$errorColour'>  </span>" > /tmp/panel_i3_data/panel_cpu.txt

sleep 2



while true; do
	"$HOME/.local/share/rc67/panel_scripts/network_down" > /tmp/panel_i3_data/panel_network_down_new.txt
	"$HOME/.local/share/rc67/panel_scripts/cpu" > /tmp/panel_i3_data/panel_cpu_new.txt
	"$HOME/.local/share/rc67/panel_scripts/uptime" > /tmp/panel_i3_data/panel_uptime_new.txt
	echo "<span foreground='#$networkDownColour'> $(cat /tmp/panel_i3_data/panel_network_down_new.txt) </span>" > /tmp/panel_i3_data/panel_network_down.txt
	echo "<span foreground='#$cpuUsageColour'> $(cat /tmp/panel_i3_data/panel_cpu_new.txt) </span>" > /tmp/panel_i3_data/panel_cpu.txt
	echo "<span foreground='#$uptimeColour'> Up $(cat /tmp/panel_i3_data/panel_uptime_new.txt) </span>" > /tmp/panel_i3_data/panel_uptime.txt
 	sleep 2
done
