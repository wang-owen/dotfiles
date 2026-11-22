#!/usr/bin/env bash
# Blank all outputs until the next input. Bound on key release so the Escape
# release can't wake them. swayidle only fires resume after a timeout has
# fired, so arm a 1s no-op timeout and use its resume to power back on.
pkill -f 'swayidle -w timeout 1 ' 2>/dev/null
swaymsg 'output * power off' >/dev/null
exec swayidle -w timeout 1 true \
  resume 'swaymsg "output * power on"; kill $PPID'
