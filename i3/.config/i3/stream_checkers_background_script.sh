#!/usr/bin/env sh

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_1.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_2.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_3.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_4.txt

sleep 3

while true; do
	"$XDG_DATA_HOME/rc67/panel_scripts/panel_stream_checker.sh" -c 1 i3 > /tmp/panel_i3_data/panel_stream_1_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_1_new.txt)" > /tmp/panel_i3_data/panel_stream_1.txt
	"$XDG_DATA_HOME/rc67/panel_scripts/panel_stream_checker.sh" -c 2 i3 > /tmp/panel_i3_data/panel_stream_2_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_2_new.txt)" > /tmp/panel_i3_data/panel_stream_2.txt
	"$XDG_DATA_HOME/rc67/panel_scripts/panel_stream_checker.sh" -c 3 i3 > /tmp/panel_i3_data/panel_stream_3_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_3_new.txt)" > /tmp/panel_i3_data/panel_stream_3.txt
	"$XDG_DATA_HOME/rc67/panel_scripts/panel_stream_checker.sh" -c 4 i3 > /tmp/panel_i3_data/panel_stream_4_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_4_new.txt)" > /tmp/panel_i3_data/panel_stream_4.txt
 	sleep 300
done
