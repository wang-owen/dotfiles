#!/usr/bin/env bash
# Make the GDM greeter suspend after 15 min idle on AC, the GNOME default that
# Ubuntu overrides to never. swayidle in sway/config only runs inside a sway
# session, so once logged out the greeter decides.
# Away mode's sleep inhibitor still blocks this.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

CONF=/etc/gdm3/greeter.dconf-defaults
if [[ ! -f $CONF ]]; then
  echo "$CONF not found; skipping GDM suspend setup" >&2
  exit 0
fi

sudo sed -i -E \
  -e "s/^#? ?sleep-inactive-ac-timeout=.*/sleep-inactive-ac-timeout=900/" \
  -e "s/^#? ?sleep-inactive-ac-type=.*/sleep-inactive-ac-type='suspend'/" \
  "$CONF"

grep -q '^sleep-inactive-ac-timeout=900$' "$CONF" && grep -q "^sleep-inactive-ac-type='suspend'$" "$CONF" || {
  echo "Failed to set suspend keys in $CONF" >&2
  exit 1
}
echo "GDM greeter will suspend after 15 min idle (applies when gdm restarts or on reboot)"
