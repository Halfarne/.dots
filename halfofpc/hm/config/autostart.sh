#!/usr/bin/env bash

#exec ~/.config/plocha.sh &&

exec wbg ~/.config/plocha.jpg &&

exec dunst && 

exec "gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Noir-Dark-GTK'" &
#exec "gsettings set org.gnome.desktop.interface icon-theme 'ePapirus'" &
exec "gsettings set org.gnome.desktop.interface font-name 'Space Mono 11'"

#exec "wal -t --theme .config/pywaltheme-new.json"
#wal -R
