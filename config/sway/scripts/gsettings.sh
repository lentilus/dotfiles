#!/bin/bash

notify-send "checking catppuccin"

# boostrap catppuccin
version="v0.6.1"
url="https://github.com/catppuccin/gtk/releases/download/$version/Catppuccin-Mocha-Standard-Blue-Dark.zip"
dest="$HOME/.local/share/themes"

if [ ! -e "$dest/Catppuccin-Mocha-Standard-Blue-dark" ]; then
  mkdir -p "$dest"
  curl -L $url -o ~/.local/share/themes/catppuccin.zip
  unzip "$dest/catppuccin.zip" -d "$dest"
  rm -rf "$dest"/catppuccin.zip
fi 

notify-send "apply gtk settings"

# apply gtk settings
gnome_schema=org.gnome.desktop.interface
gsettings set "$gnome_schema" gtk-theme 'Catppuccin-Mocha-Standard-Blue-dark'
gsettings set "$gnome_schema" color-scheme prefer-dark
gsettings set "$gnome_schema" font-name 'JetBrains Mono Nerd Font Mono'
gsettings set "$gnome_schema" scaling-factor '1'
gsettings set "$gnome_schema" text-scaling-factor '1'
#gsettings set "$gnome_schema" icon-theme 'Your icon theme'
#gsettings set "$gnome_schema" cursor-theme 'Your cursor Theme'


