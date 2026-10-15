#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PACMAN_PACKAGES=(
  zsh
  neovim
  tmux
  git
  fastfetch
  eza
  bat
  ripgrep
  fd
  fzf
  zoxide
  btop
  chafa
  git-delta
  lazygit
  yazi
  wl-clipboard
  gcc
  pypy3
  ttc-iosevka
)

echo "Installing packages via pacman..."
sudo pacman -Syu --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# antidote is only in the AUR — install via git clone
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "Cloning antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "antidote already installed at $ANTIDOTE_DIR"
fi

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo "Setting zsh as the login shell..."
  chsh -s "$(command -v zsh)"
fi

bash "$DOTFILES/link.sh"
