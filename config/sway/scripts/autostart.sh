#!/bin/bash

# NOTE, that i also have stuff to autostart in my fish-config

notify-send autostarting programms

gpg-agent &
foot --server &
kanshi &
ydotoold &
autotiling &
/usr/libexec/polkit-gnome-authentication-agent-1 &
nm-applet --indicator &
flatpak run org.signal.Signal --start-in-tray &

