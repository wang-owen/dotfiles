#!/usr/bin/env bash

set -e

# Under sudo, $HOME is /root and everything lands in root's home
if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Homebrew's installer also installs the Xcode Command Line Tools (C++ compiler)
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages via brew bundle..."
brew bundle --file="$DOTFILES/Brewfile"

bash "$DOTFILES/link.sh"
