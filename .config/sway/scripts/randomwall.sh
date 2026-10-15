#!/bin/bash

CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_LINK="$CACHE_DIR/current_wallpaper"
WALL_DIR="$HOME/Pictures/Wallpapers"

WALL=$(find "$WALL_DIR" -type f | shuf -n1)

if [ -z "$WALL" ]; then
    exit 1
fi

mkdir -p "$CACHE_DIR"
ln -sfn "$WALL" "$LOCK_LINK"

pkill -x swaybg 2>/dev/null

swaybg -i "$LOCK_LINK" -m fill &
