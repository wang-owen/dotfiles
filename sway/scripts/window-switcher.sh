#!/usr/bin/env bash
# Focus a window picked in fuzzel
set -euo pipefail

windows="$(swaymsg -t get_tree | jq -r '
  recurse(.nodes[]?, .floating_nodes[]?)
  | select(.type == "workspace" and .name != "__i3_scratch") as $ws
  | $ws | recurse(.nodes[]?, .floating_nodes[]?) | select(.pid)
  | "\(.id)\t[\($ws.name)] \(.app_id // .window_properties.class // "?"): \(.name)"')"

mapfile -t rows <<<"$windows"
choice="$(printf '%s\n' "${rows[@]#*$'\t'}" | fuzzel --dmenu --index --prompt 'window: ')" || exit 0
# Ignore input that matches nothing
[[ $choice =~ ^[0-9]+$ ]] || exit 0
id="${rows[choice]%%$'\t'*}"
swaymsg "[con_id=$id] focus" >/dev/null
