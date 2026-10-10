#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "Cloning antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "antidote already installed at $ANTIDOTE_DIR"
fi

bash "$DOTFILES/link.sh"
