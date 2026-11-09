#!/usr/bin/env bash
# Startet die Leiste neu und gibt Informationen zurück, die ich zum Weiterbauen brauche.
cd "$(dirname "$0")/.." || exit 1
echo "== Einrichtung (Ende des Protokolls) =="
tail -8 ~/setup.log 2>/dev/null || echo "kein setup.log"
echo
echo "== Hyprland-Konfiguration: Start, Tasten, Regeln =="
grep -n -i -E "exec|autostart|hl\.bind|mainMod|terminal|launcher|layer_rule|layerrule|hl\.env|env\(" ~/.config/hypr/hyprland.lua | head -60
echo
echo "== Leiste starten =="
bash scripts/run-shell.sh
