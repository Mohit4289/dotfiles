#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_LINK="$CACHE_DIR/current_wallpaper"

selected=$(
for img in "$WALL_DIR"/*; do
    [ -f "$img" ] || continue
    printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
done | rofi \
    -dmenu \
    -show-icons \
    -theme ~/.config/rofi/wallpaper.rasi \
    -p "~/Pictures/Wallpapers"
)

if [ -n "$selected" ]; then
    WALL="$WALL_DIR/$selected"

    # Update wallpaper symlink
    mkdir -p "$CACHE_DIR"
    ln -sfn "$WALL" "$LOCK_LINK"

    # Replace existing swaybg
    pkill -x swaybg 2>/dev/null
    swaybg -i "$LOCK_LINK" -m fill &
fi
