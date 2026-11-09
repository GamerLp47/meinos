#!/usr/bin/env bash
# Einmalige Einrichtung in der VM. Aufruf: sudo bash scripts/setup.sh
# Installiert Symbole, Dateimanager und die Schriften der Oberfläche.
set -u
U=${SUDO_USER:-joshurea}
H=$(getent passwd "$U" | cut -d: -f6)
LOG="$H/setup.log"
exec > >(tee "$LOG") 2>&1

echo "== Pakete =="
pacman -S --needed --noconfirm thunar papirus-icon-theme foot xdg-utils

echo "== Schriften =="
FD="$H/.local/share/fonts/meinos"
sudo -u "$U" mkdir -p "$FD"
cp -f "$(dirname "$0")/../fonts/"*.ttf "$FD/"
chown -R "$U":"$U" "$H/.local/share/fonts"
sudo -u "$U" fc-cache -f
fc-list | grep -i -E "sora|manrope" | head -4

echo "== Fertig =="
