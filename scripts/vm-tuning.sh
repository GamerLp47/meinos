#!/usr/bin/env bash
# Schaltet in der VM Schatten, Unschärfe und Animationen von Hyprland ab.
# Sichert die Konfiguration einmalig als hyprland.lua.orig.
f=~/.config/hypr/hyprland.lua
cp -n "$f" "$f.orig"

off() {
  local n=$1 key=$2
  if sed -n "$((n-1))p" "$f" | grep -q "$key" && sed -n "${n}p" "$f" | grep -q "enabled *= true"; then
    sed -i "${n}s/= true/= false/" "$f"
    echo "aus: $key (Zeile $n)"
  else
    echo "uebersprungen: $key (Zeile $n passt nicht)"
  fi
}

off 124 shadow
off 131 blur
off 139 animations

echo "--- Monitor-Abschnitt ---"
sed -n '22,34p' "$f"
