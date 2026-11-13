#!/usr/bin/env bash
# Close all windows on the workspace but the focused one
set -euo pipefail

swaymsg -t get_tree | jq -r '
  recurse(.nodes[]?, .floating_nodes[]?)
  | select(.type == "workspace" and any(recurse(.nodes[]?, .floating_nodes[]?); .focused))
  | recurse(.nodes[]?, .floating_nodes[]?)
  | select(.pid and (.focused | not)) | "[con_id=\(.id)] kill"' |
  paste -sd';' | xargs -r -d '\n' swaymsg >/dev/null
