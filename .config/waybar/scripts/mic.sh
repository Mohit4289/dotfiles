#!/usr/bin/env bash
mute=$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $2}')
vol=$(pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null | grep -Po '[0-9]+(?=%)' | head -n1)

if [ "$mute" = "yes" ]; then
    printf '{"text": "  muted", "tooltip": "Microphone: Muted (%s%%)", "class": "muted"}\n' "${vol:-0}"
else
    printf '{"text": "  %s%%", "tooltip": "Microphone: %s%%", "class": "unmuted"}\n' "${vol:-0}" "${vol:-0}"
fi
