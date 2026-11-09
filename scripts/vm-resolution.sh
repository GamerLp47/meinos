#!/usr/bin/env bash
# Stellt die Auflösung in der VM ein. Aufruf: bash scripts/vm-resolution.sh [Modus]
# Beispiel: bash scripts/vm-resolution.sh 1920x1080@60
MODE=${1:-1920x1080@60}
f=~/.config/hypr/hyprland.lua
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | head -1)

cp -n "$f" "$f.orig"
if sed -n '28p' "$f" | grep -q 'mode *='; then
  sed -i "28s/\"[^\"]*\"/\"$MODE\"/" "$f"
  echo "Zeile 28 gesetzt: $(sed -n '28p' "$f")"
else
  echo "Zeile 28 ist keine mode-Zeile:"; sed -n '24,32p' "$f"
fi

hyprctl reload > /dev/null 2>&1
sleep 2
echo "--- configerrors ---"; hyprctl configerrors 2>&1
echo "--- Monitore ---"
hyprctl monitors 2>&1 | grep -i -E "Monitor|@|availableModes" | cut -c1-300
