#!/usr/bin/env bash
# Schaltet in der VM den Hardware-Mauszeiger ab (Software-Zeiger ruckelt dort weniger).
f=~/.config/hypr/hyprland.lua
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | head -1)

cp -n "$f" "$f.orig"
if grep -q "MEINOS-VM-CURSOR" "$f"; then
  echo "Eintrag existiert schon, nichts geaendert."
else
  printf '\n-- MEINOS-VM-CURSOR\nhl.config({ cursor = { no_hardware_cursors = 1 } })\n' >> "$f"
  echo "Eintrag angehaengt (Wert 1)."
fi

hyprctl reload > /dev/null 2>&1
sleep 1
err=$(hyprctl configerrors 2>&1)
if echo "$err" | grep -qi "cursor\|no_hardware"; then
  echo "Fehler mit Wert 1, versuche true ..."
  sed -i 's/no_hardware_cursors = 1/no_hardware_cursors = true/' "$f"
  hyprctl reload > /dev/null 2>&1
  sleep 1
  err=$(hyprctl configerrors 2>&1)
fi
echo "--- configerrors ---"
echo "${err:-keine}"
tail -3 "$f"
