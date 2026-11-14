#!/usr/bin/env bash
# Power menu for the waybar button
set -euo pipefail

choice="$(printf '%s\n' \
  '󰌾  Lock' \
  '󰤄  Sleep' \
  '󰍃  Log Out' \
  '󰜉  Restart' \
  '󰐥  Shut Down' |
  fuzzel --dmenu --lines 5 --width 16 --prompt '' --no-sort)" || exit 0

case "$choice" in
  *Lock) loginctl lock-session ;; # swayidle runs $lock
  *Sleep) systemctl suspend ;;    # swayidle locks before sleep
  *'Log Out') swaymsg exit ;;
  *Restart) systemctl reboot ;;
  *'Shut Down') systemctl poweroff ;;
esac
