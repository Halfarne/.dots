#!/usr/bin/env bash

rm ~/.config/hypr/barvy.conf

echo "\$aktivni = "$(cat ~/.cache/wal/colors.json | jq '.colors.color3 | sub("#"; "0xee")' -r | awk '{print tolower($0)}') >> ~/.config/hypr/barvy.conf

echo "\$neaktivni = "$(cat ~/.cache/wal/colors.json | jq '.colors.color9 | sub("#"; "0xee")' -r | awk '{print tolower($0)}') >> ~/.config/hypr/barvy.conf
