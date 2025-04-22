#!/bin/bash

export PATH="$PATH:/home/scriptwiz/.local/bin"

THEME_FILE="/tmp/theme_variant"
wal_arguments=""

if [ -s "$THEME_FILE" ]; then
  case $(<"$THEME_FILE") in
    "light") wal_arguments="lighten -l" ;;
  esac
fi

wal -i ~/wallpaper/wallpaper.png $wal_arguments --vte -e

if pgrep -x "waybar" >/dev/null; then
    killall waybar
fi

waybar &

swaync-client -rs
pywalfox update
