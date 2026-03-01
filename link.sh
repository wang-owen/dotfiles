#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "Linked $dst -> $src"
}

# Whole folders
link "fastfetch"  "$HOME/.config/fastfetch"
link "nvim"       "$HOME/.config/nvim"
link "yazi"       "$HOME/.config/yazi"
link "ghostty"    "$HOME/.config/ghostty"

# zsh (files go directly in ~)
link "zsh/.zshrc"           "$HOME/.zshrc"
link "zsh/.p10k.zsh"        "$HOME/.p10k.zsh"
link "zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

# tmux
link "tmux/tmux.conf" "$HOME/.tmux.conf"

# git
link "git/gitconfig" "$HOME/.gitconfig"

echo "Done."
