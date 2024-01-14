#! /usr/bin/env bash

okno=$(hyprctl activewindow -j | jq -r '"./" + .class + " - " + .title')
nic="./ - "

if [[ "$nic" == "$okno" ]]
then
    echo " - "
else
    hyprctl activewindow -j | jq -r '"./" + .class + " - " + .title'
fi
