#!/usr/bin/env bash
# Install away mode's root-owned pieces. Copies, not symlinks: the user may
# start this unit without a password, so its file must not be user-writable.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo install -m 644 -o root -g root "$DIR/away.service" /etc/systemd/system/away.service
sudo systemctl daemon-reload

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
cat >"$tmp" <<RULE
# Installed by ~/dotfiles/away/install.sh: passwordless away mode toggle
$USER ALL=(root) NOPASSWD: /usr/bin/systemctl enable --now away.service, /usr/bin/systemctl disable --now away.service
RULE
visudo -cqf "$tmp"
sudo install -m 440 -o root -g root "$tmp" /etc/sudoers.d/away

echo "Installed away.service and /etc/sudoers.d/away"
