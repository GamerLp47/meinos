#!/bin/bash
# Alle Fenster öffnen frei schwebend (Kacheln per Super+V pro Fenster umschaltbar).
f=~/.config/hypr/hyprland.lua
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -1)
if ! grep -q MEINOS-FLOAT "$f"; then
cat >> "$f" <<'LUA'

-- MEINOS-FLOAT
hl.window_rule({
    name  = "meinos-float-all",
    match = { class = ".*" },
    float = true,
})
LUA
fi
hyprctl reload; sleep 1
echo "== Fehler =="; hyprctl configerrors
echo "== Ende =="
