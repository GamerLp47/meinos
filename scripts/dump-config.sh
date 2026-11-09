#!/bin/bash
# Zeigt die Stellen der Hyprland-Konfiguration, die wir als Nächstes ändern.
f=~/.config/hypr/hyprland.lua
echo "== Zeilen 40-62 =="; sed -n '40,62p' "$f"
echo "== Zeilen 92-140 =="; sed -n '92,140p' "$f"
echo "== Binds mit menu/exec =="; grep -n 'menu\|exec_cmd' "$f" | head -30
