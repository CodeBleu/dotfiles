#!/bin/bash
# Check tmux env var directly
enabled=$(tmux showenv -g TMUX_SHOW_BATTERY 2>/dev/null | cut -d= -f2)
[ "$enabled" = "1" ] || exit 0

BAT_PATH="/sys/class/power_supply/BAT0"
[ -d "$BAT_PATH" ] || exit 0

capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null) || exit 0
status=$(cat "$BAT_PATH/status" 2>/dev/null)

if [ "$status" = "Charging" ]; then
    icon="⚡"
elif [ "$capacity" -ge 20 ]; then
    icon="🔋"
else
    icon="🪫"
fi

echo " $icon ${capacity}% "
