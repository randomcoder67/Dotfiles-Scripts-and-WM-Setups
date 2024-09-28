#!/usr/bin/env sh

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_1.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_2.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_3.txt
echo "<span foreground='#709289'>  </span>" > /tmp/panel_i3_data/panel_stream_4.txt

sleep 3

while true; do
	~/.config/i3/i3_panel_stream_checker.sh -c 1 > /tmp/panel_i3_data/panel_stream_1_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_1_new.txt)" > /tmp/panel_i3_data/panel_stream_1.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 2 > /tmp/panel_i3_data/panel_stream_2_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_2_new.txt)" > /tmp/panel_i3_data/panel_stream_2.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 3 > /tmp/panel_i3_data/panel_stream_3_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_3_new.txt)" > /tmp/panel_i3_data/panel_stream_3.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 4 > /tmp/panel_i3_data/panel_stream_4_new.txt
	echo "$(cat /tmp/panel_i3_data/panel_stream_4_new.txt)" > /tmp/panel_i3_data/panel_stream_4.txt
 	sleep 300
done
