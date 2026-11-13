#!/usr/bin/env bash
# AeroSpace's resize smart: resize along the parent's orientation

set -euo pipefail

action="${1:?usage: smart-resize.sh grow|shrink}"

layout="$(swaymsg -t get_tree | jq -r '
  first(recurse(.nodes[]?, .floating_nodes[]?) | select(any(.nodes[]?; .focused)) | .layout)')"

case "$layout" in
  splitv | stacked) dim=height ;;
  *) dim=width ;;
esac

swaymsg resize "$action" "$dim" 50 px or 5 ppt
