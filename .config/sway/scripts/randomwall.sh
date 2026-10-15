#!/usr/bin/env bash
# ==============================================================================
#  Random Wallpaper Picker for Sway / SwayFX
# ==============================================================================

set -e

WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_LINK="$CACHE_DIR/current_wallpaper"

# Pick a random image excluding the current active wallpaper.png
WALL=$(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) ! -name "wallpaper.png" | shuf -n1)

if [ -z "$WALL" ]; then
    exit 1
fi

mkdir -p "$CACHE_DIR"
cp -f "$WALL" "$WALL_DIR/wallpaper.png"
ln -sfn "$WALL_DIR/wallpaper.png" "$LOCK_LINK"

pkill -x swaybg 2>/dev/null || true
swaybg -i "$WALL_DIR/wallpaper.png" -m fill &

if command -v notify-send &>/dev/null; then
    title=$(basename "$WALL")
    title="${title%.*}"
    title="${title//_/ }"
    title="${title//-/ }"
    notify-send -a "Sway" -i "$WALL" "Random Wallpaper" "$title" 2>/dev/null || true
fi
