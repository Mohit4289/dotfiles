#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar_hidden"

if [ -f "$STATE_FILE" ]; then
    pkill -SIGUSR2 -x waybar
    rm -f "$STATE_FILE"
else
    pkill -SIGUSR1 -x waybar
    touch "$STATE_FILE"
fi
