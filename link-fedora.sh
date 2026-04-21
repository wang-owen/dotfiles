#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---Packages---

DNF_PACKAGES=(
  zsh
  neovim
  tmux
  git
  fastfetch
  eza
  bat
  ripgrep
  fd-find
  fzf
  zoxide
  btop
  git-delta
  lazygit
  yazi
  wl-clipboard  # provides wl-copy for Wayland clipboard
)

# Enable COPR repos for packages not in the default Fedora repos
echo "Enabling COPR repos..."
sudo dnf copr enable -y atim/lazygit
sudo dnf copr enable -y varlad/yazi

echo "Installing packages via dnf..."
sudo dnf install -y "${DNF_PACKAGES[@]}"

# antidote is not in the Fedora repos — install via git clone
ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "Cloning antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "antidote already installed at $ANTIDOTE_DIR"
fi

# ---Linking---

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

# zsh (files go directly in ~)
link "zsh/.zshrc.linux"     "$HOME/.zshrc"
link "zsh/.p10k.zsh"        "$HOME/.p10k.zsh"
link "zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

# tmux
link "tmux/tmux.conf" "$HOME/.tmux.conf"

# git
link "git/gitconfig" "$HOME/.gitconfig"

echo "Done. Restart your shell or run: exec zsh"
