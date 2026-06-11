#!/bin/sh

LOGFILE="/tmp/qtile-autostart.log"
echo "$(date) === Qtile autostart started ===" >> "$LOGFILE"

/usr/libexec/polkit-gnome-authentication-agent-1 >> "$LOGFILE" 2>&1 &
#
# kill old instances
pkill -x pipewire pipewire-pulse wireplumber || true
sleep 0.2

# start PipeWire stack (no --daemon)
pipewire &
pipewire-pulse &
wireplumber &
# Start Picom (modern version - no experimental-backends)
picom --config ~/.config/picom/picom.conf --daemon >> "$LOGFILE" 2>&1 &

# Wait a bit for display to be ready
sleep 0.2

# Start applets
nm-applet >> "$LOGFILE" 2>&1 &
# flameshot >> "$LOGFILE" 2>&1 &

# start light-locker
echo "starting light-locker at $(date)" >> "$LOGFILE"
light-locker >> "$LOGFILE" 2>&1 &

# Other stuff
xmodmap ~/.Xmodmap >> "$LOGFILE" 2>&1 &

echo "$(date) === Qtile autostart finished ===" >> "$LOGFILE"
