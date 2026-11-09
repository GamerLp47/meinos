#!/bin/bash
# Öffnet/schließt den Starter. Probiert mehrere Schreibweisen von quickshell.
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export LANG=C.UTF-8
P="$HOME/meinos/shell"
quickshell -p "$P" ipc call launcher toggle >/tmp/launcher-toggle.log 2>&1 && exit 0
quickshell ipc -p "$P" call launcher toggle >>/tmp/launcher-toggle.log 2>&1 && exit 0
exit 1
