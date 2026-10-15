#!/usr/bin/env bash

set -e

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
  curl
  unzip
  fontconfig
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
  wl-clipboard
  gcc-c++ libasan libubsan
  pypy3
)

# Enable COPR repos for packages not in the default Fedora repos
echo "Enabling COPR repos..."
sudo dnf copr enable -y atim/lazygit
sudo dnf copr enable -y varlad/yazi

echo "Installing packages via dnf..."
sudo dnf install -y "${DNF_PACKAGES[@]}"

# Iosevka Term is not in the Fedora repos — install via GitHub release
FONT_DIR="$HOME/.local/share/fonts/iosevka-term"
if [[ ! -d "$FONT_DIR" ]]; then
  echo "Installing Iosevka Term..."
  IOSEVKA_VERSION="34.9.0"
  curl -fsSL "https://github.com/be5invis/Iosevka/releases/download/v${IOSEVKA_VERSION}/PkgTTC-SGr-IosevkaTerm-${IOSEVKA_VERSION}.zip" -o /tmp/iosevka-term.zip
  mkdir -p "$FONT_DIR"
  unzip -o /tmp/iosevka-term.zip -d "$FONT_DIR"
  rm /tmp/iosevka-term.zip
  fc-cache -f "$FONT_DIR"
else
  echo "Iosevka Term already installed at $FONT_DIR"
fi

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
