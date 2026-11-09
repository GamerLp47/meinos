#!/bin/bash
f=~/.config/hypr/hyprland.lua
sed -i 's|quickshell ipc call launcher toggle|bash " .. os.getenv("HOME") .. "/meinos/scripts/launcher-toggle.sh|g' "$f"
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -1)
hyprctl reload; sleep 1
echo "== Fehler =="; hyprctl configerrors
grep -n 'launcher-toggle' "$f"
echo "== Test =="; bash ~/meinos/scripts/launcher-toggle.sh; echo "Exit: $?"; cat /tmp/launcher-toggle.log | grep -v 'locale\|Qt depends\|If this\|for more'
echo "== Super+Maus-Binds =="; grep -n 'mouse' "$f" | head
