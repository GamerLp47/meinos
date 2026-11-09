#!/usr/bin/env bash
# Skalierung 100 %, dunkle und kleinere GTK-Programme, Bericht für den nächsten Schritt.
f=~/.config/hypr/hyprland.lua
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr" | head -1)
cp -n "$f" "$f.orig"

# Skalierung
if sed -n '30p' "$f" | grep -q 'scale *='; then
  sed -i '30s/"[^"]*"/"1"/' "$f"
  echo "Zeile 30: $(sed -n '30p' "$f")"
else
  echo "Zeile 30 ist keine scale-Zeile:"; sed -n '26,32p' "$f"
fi

# GTK: dunkel, kleinere Schrift, Papirus-Symbole
for v in 3.0 4.0; do
  mkdir -p ~/.config/gtk-$v
  cat > ~/.config/gtk-$v/settings.ini <<'EOT'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-font-name=Manrope 12
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-size=24
EOT
done

hyprctl reload > /dev/null 2>&1
sleep 1
echo "--- configerrors ---"; hyprctl configerrors 2>&1
echo "--- scale ---"; hyprctl monitors 2>&1 | grep -i -E "scale|@"
echo "--- Autostart (Zeilen 44-60) ---"; sed -n '44,60p' "$f"
echo "--- General/Rand (Zeilen 95-137) ---"; sed -n '95,137p' "$f"
