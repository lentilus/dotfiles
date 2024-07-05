#!/bin/bash

swayidle -w \
	timeout 300 \
	'swaylock -f -i /home/lentilus/Downloads/wallpaper.jpg' \
	timeout 600 \
	'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
	before-sleep 'swaylock -f -i /home/lentilus/Downloads/wallpaper.jpg'
