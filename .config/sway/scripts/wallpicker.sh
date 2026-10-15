#!/usr/bin/env bash
# ==============================================================================
#  Minimalist Wallpaper Picker for Sway / SwayFX
# ==============================================================================

set -e

WALL_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper_thumbnails"
CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_LINK="$CACHE_DIR/current_wallpaper"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"

mkdir -p "$WALL_DIR" "$THUMB_DIR" "$CACHE_DIR"

# Generate missing or outdated thumbnails
for img in "$WALL_DIR"/*; do
    [ -f "$img" ] || continue
    case "${img,,}" in
        *.png|*.jpg|*.jpeg|*.webp) ;;
        *) continue ;;
    esac

    filename=$(basename "$img")
    # Skip current active wallpaper symlink / duplicate
    [ "$filename" = "wallpaper.png" ] && continue

    thumb="$THUMB_DIR/${filename%.*}.jpg"
    if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
        if command -v magick &>/dev/null; then
            magick "$img" -thumbnail 320x180^ -gravity center -extent 320x180 "$thumb" 2>/dev/null || cp "$img" "$thumb"
        else
            thumb="$img"
        fi
    fi
done

# Build Rofi menu items
rofi_input=""
declare -A file_map

for img in "$WALL_DIR"/*; do
    [ -f "$img" ] || continue
    case "${img,,}" in
        *.png|*.jpg|*.jpeg|*.webp) ;;
        *) continue ;;
    esac

    filename=$(basename "$img")
    [ "$filename" = "wallpaper.png" ] && continue

    thumb="$THUMB_DIR/${filename%.*}.jpg"
    [ -f "$thumb" ] || thumb="$img"

    # Human-friendly display title
    title="${filename%.*}"
    title="${title//_/ }"
    title="${title//-/ }"

    file_map["$title"]="$img"
    rofi_input+="${title}\0icon\x1f${thumb}\n"
done

# Run Rofi selector
selected_title=$(printf "%b" "$rofi_input" | rofi \
    -dmenu \
    -show-icons \
    -theme "$ROFI_THEME" \
    -p "󰸉 Wallpapers" \
    -i)

if [ -n "$selected_title" ]; then
    selected_file="${file_map[$selected_title]}"
    
    if [ -f "$selected_file" ]; then
        # 1. Update persistent wallpaper file for swaylock & sway sessions
        cp -f "$selected_file" "$WALL_DIR/wallpaper.png"

        # 2. Update volatile runtime symlink
        ln -sfn "$WALL_DIR/wallpaper.png" "$LOCK_LINK"

        # 3. Reload wallpaper live seamlessly
        if command -v swaybg &>/dev/null; then
            pkill -x swaybg 2>/dev/null || true
            swaybg -i "$WALL_DIR/wallpaper.png" -m fill &
        elif command -v swaymsg &>/dev/null; then
            swaymsg "output * bg $WALL_DIR/wallpaper.png fill" 2>/dev/null || true
        fi

        # 4. Desktop notification
        thumb="$THUMB_DIR/$(basename "$selected_file" | sed 's/\.[^.]*$/.jpg/')"
        if command -v notify-send &>/dev/null; then
            notify-send -a "Sway" -i "${thumb:-$selected_file}" "Wallpaper Applied" "$selected_title" 2>/dev/null || true
        fi
    fi
fi
