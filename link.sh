#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

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
link "lazygit"    "$HOME/.config/lazygit"
link "btop"       "$HOME/.config/btop"

# zsh
link "zsh/.zshrc"           "$HOME/.zshrc"
link "zsh/.zprofile"        "$HOME/.zprofile"
link "zsh/.p10k.zsh"        "$HOME/.p10k.zsh"
link "zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

# tmux
link "tmux/tmux.conf" "$HOME/.tmux.conf"

# git
link "git/gitconfig" "$HOME/.gitconfig"
link "git/ignore"    "$HOME/.config/git/ignore"

# claude code
link "claude/settings.json"         "$HOME/.claude/settings.json"
link "claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# competitive programming
for f in template.cc template.py dbg.h compile_flags.txt; do
  link "cp/$f" "$HOME/Developer/cp/$f"
done

if [[ "$(uname)" == "Darwin" ]]; then
  link "aerospace"          "$HOME/.config/aerospace"
  link "clangd/config.yaml" "$HOME/Library/Preferences/clangd/config.yaml"
else
  link "clangd/config.yaml" "$HOME/.config/clangd/config.yaml"
fi

echo "Done. Restart your shell or run: exec zsh"
