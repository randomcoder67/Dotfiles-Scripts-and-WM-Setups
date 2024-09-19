#!/usr/bin/env sh

[ -d "/tmp/panel_i3_data" ] || mkdir "/tmp/panel_i3_data"

while true; do
	~/.config/i3/i3_panel_stream_checker.sh -c 1 > /tmp/panel_i3_data/panel_1_new.txt
	echo "D:$(cat /tmp/panel_i3_data/panel_1_new.txt)" > /tmp/panel_i3_data/panel_1.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 2 > /tmp/panel_i3_data/panel_2_new.txt
	echo "C:$(cat /tmp/panel_i3_data/panel_2_new.txt)" > /tmp/panel_i3_data/panel_2.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 3 > /tmp/panel_i3_data/panel_3_new.txt
	echo "K:$(cat /tmp/panel_i3_data/panel_3_new.txt)" > /tmp/panel_i3_data/panel_3.txt
	~/.config/i3/i3_panel_stream_checker.sh -c 4 > /tmp/panel_i3_data/panel_4_new.txt
	echo "N:$(cat /tmp/panel_i3_data/panel_4_new.txt)" > /tmp/panel_i3_data/panel_4.txt
 	sleep 300
done
