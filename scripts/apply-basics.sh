#!/bin/bash
# Grundlagen: Leiste startet automatisch, SUPER+R / SUPER+Leertaste öffnet den Starter,
# Thunar als Dateimanager, weinroter Rahmen, Fenster am Rand greifbar.
f=~/.config/hypr/hyprland.lua
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -1)
[ -f "$f.vorbasics" ] || cp "$f" "$f.vorbasics"

sed -i 's|^local fileManager = .*|local fileManager = "thunar"|' "$f"
sed -i 's|^\( *active_border *= *\).*|\1{ colors = {"rgba(c0292bee)", "rgba(5a1012ee)"}, angle = 45 },|' "$f"
sed -i 's|^\( *inactive_border *= *\).*|\1"rgba(ffffff1f)",|' "$f"
sed -i 's|resize_on_border = false|resize_on_border = true|' "$f"
sed -i 's|^hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))|hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("quickshell ipc call launcher toggle"))|' "$f"

if ! grep -q MEINOS-BASICS "$f"; then
cat >> "$f" <<'LUA'

-- MEINOS-BASICS
hl.on("hyprland.start", function ()
    hl.exec_cmd("bash " .. os.getenv("HOME") .. "/meinos/scripts/run-shell.sh")
end)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("quickshell ipc call launcher toggle"))
LUA
fi

sleep 1
hyprctl reload
sleep 1
echo "== Fehler =="; hyprctl configerrors
echo "== Rahmen =="; grep -n 'active_border\|fileManager =\|launcher toggle' "$f"
