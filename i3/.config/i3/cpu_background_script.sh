#!/usr/bin/env sh

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_cpu.txt

sleep 2

while true; do
	"$HOME/.local/share/rc67/panel_scripts/cpu" > /tmp/panel_i3_data/panel_cpu_new.txt
	"$HOME/.local/share/rc67/panel_scripts/uptime" > /tmp/panel_i3_data/panel_uptime_new.txt
	echo "<span foreground='#709289'> $(cat /tmp/panel_i3_data/panel_cpu_new.txt) </span>" > /tmp/panel_i3_data/panel_cpu.txt
	echo "<span foreground='#f9d25b'> Up $(cat /tmp/panel_i3_data/panel_uptime_new.txt) </span>" > /tmp/panel_i3_data/panel_uptime.txt
 	sleep 2
done
