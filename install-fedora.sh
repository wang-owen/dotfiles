#!/usr/bin/env bash

set -e

# Under sudo, $HOME is /root and everything lands in root's home
if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

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
  chafa
  git-delta
  lazygit
  yazi
  wl-clipboard  # provides wl-copy for Wayland clipboard
  gcc-c++ libasan libubsan  # contest builds; Fedora ships the sanitizer runtimes separately
  pypy3  # contest Python, as on the judge
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

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo "Setting zsh as the login shell..."
  chsh -s "$(command -v zsh)"
fi

bash "$DOTFILES/link.sh"
