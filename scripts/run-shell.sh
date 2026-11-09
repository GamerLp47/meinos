#!/usr/bin/env bash
# Startet die Leiste neu. Funktioniert auch per SSH, solange Hyprland in der VM läuft.
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WAYLAND_DISPLAY=$(ls "$XDG_RUNTIME_DIR" | grep -m1 -E '^wayland-[0-9]+$')
export QT_QUICK_BACKEND=${QT_QUICK_BACKEND:-software}
echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
pkill -x quickshell 2>/dev/null
cd "$(dirname "$0")/.." || exit 1
nohup quickshell -p shell > /tmp/quickshell.log 2>&1 &
sleep 4
echo "--- quickshell log ---"
cat /tmp/quickshell.log
pgrep -x quickshell > /dev/null && echo "STATUS: LAEUFT" || echo "STATUS: BEENDET"
