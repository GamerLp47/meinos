#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -1)
export WAYLAND_DISPLAY=$(cd "$XDG_RUNTIME_DIR" && ls wayland-? 2>/dev/null | head -1)
echo "== quickshell läuft? =="; pgrep -a quickshell || echo NEIN
echo "== ipc-Test =="; quickshell ipc show 2>&1 | head -10
echo "== ipc toggle =="; quickshell ipc call launcher toggle 2>&1 | head -5
echo "== Binds mit R/SPACE =="; hyprctl binds 2>&1 | grep -i -B2 -A6 'launcher' | head -40
echo "== Fehler =="; hyprctl configerrors
echo "== Log =="; tail -15 /tmp/quickshell.log 2>&1
echo "== resize_on_border =="; hyprctl getoption general:resize_on_border 2>&1
echo "== extend_border =="; hyprctl getoption general:extend_border_grab_area 2>&1
