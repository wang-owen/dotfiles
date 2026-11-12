#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Also installs the Xcode Command Line Tools
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages via brew bundle..."
brew bundle --file="$DOTFILES/Brewfile"

if ! command -v claude &>/dev/null && [[ ! -x "$HOME/.local/bin/claude" ]]; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed"
fi

bash "$DOTFILES/link.sh"
