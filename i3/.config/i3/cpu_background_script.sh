#!/usr/bin/env sh

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_cpu.txt

sleep 2

while true; do
	python3 "$HOME/.local/share/rc67/panel_scripts/xfceCpu.py" > /tmp/panel_i3_data/panel_cpu_new.txt
	echo "<span foreground='#709289'> $(cat /tmp/panel_i3_data/panel_cpu_new.txt)</span>" > /tmp/panel_i3_data/panel_cpu.txt
 	sleep 2
done
