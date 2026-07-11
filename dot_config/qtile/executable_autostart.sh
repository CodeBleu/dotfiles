#!/bin/sh

LOGFILE="/tmp/qtile-autostart.log"
echo "$(date) === Qtile autostart started ===" >> "$LOGFILE"

/usr/libexec/polkit-gnome-authentication-agent-1 >> "$LOGFILE" 2>&1 &

# Start PipeWire stack the Gentoo-supported way (handles ordering, dedup, D-Bus)
/usr/bin/gentoo-pipewire-launcher restart >> "$LOGFILE" 2>&1 &
#
# Start Picom (modern version - no experimental-backends)
picom --config ~/.config/picom/picom.conf --daemon >> "$LOGFILE" 2>&1 &

# Wait a bit for display to be ready
sleep 0.2

# Start applets
nm-applet >> "$LOGFILE" 2>&1 &
# flameshot >> "$LOGFILE" 2>&1 &

# FIX: Use nohup and disown to prevent blocking
# start light-locker
nohup light-locker >> "$LOGFILE" 2>&1 &
disown

# FIX: Run xmodmap in a detached subshell with a delay
( sleep 2 && xmodmap ~/.Xmodmap ) >> "$LOGFILE" 2>&1 &

echo "$(date) === Qtile autostart finished ===" >> "$LOGFILE"
