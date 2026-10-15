#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APT_PACKAGES=(
  zsh
  neovim
  tmux
  git
  curl
  unzip
  fontconfig
  bat
  ripgrep
  fd-find
  fzf
  btop
  chafa
  g++
  pypy3
)

echo "Updating package index..."
sudo apt update

echo "Installing packages via apt..."
sudo apt install -y "${APT_PACKAGES[@]}"

# Ubuntu renames bat and fd
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd

# fastfetch is not in the default Ubuntu repos — install via GitHub release
if ! command -v fastfetch &>/dev/null; then
  echo "Installing fastfetch..."
  FASTFETCH_VERSION="2.40.3"
  curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -o /tmp/fastfetch.deb
  sudo apt install -y /tmp/fastfetch.deb
  rm /tmp/fastfetch.deb
else
  echo "fastfetch already installed"
fi

# eza is not in the default Ubuntu repos — install via official apt repo
if ! command -v eza &>/dev/null; then
  echo "Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
else
  echo "eza already installed"
fi

# zoxide is not in the default Ubuntu repos — install via script
if ! command -v zoxide &>/dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "zoxide already installed"
fi

# git-delta is not in the default Ubuntu repos — install via GitHub release
if ! command -v delta &>/dev/null; then
  echo "Installing git-delta..."
  DELTA_VERSION="0.18.2"
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb" -o /tmp/git-delta.deb
  sudo apt install -y /tmp/git-delta.deb
  rm /tmp/git-delta.deb
else
  echo "git-delta already installed"
fi

# lazygit is not in the default Ubuntu repos — install via GitHub release
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION="0.44.1"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  rm /tmp/lazygit.tar.gz /tmp/lazygit
else
  echo "lazygit already installed"
fi

# yazi is not in the default Ubuntu repos — install via GitHub release
if ! command -v yazi &>/dev/null; then
  echo "Installing yazi..."
  YAZI_VERSION="25.4.8"
  curl -fsSL "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip" -o /tmp/yazi.zip
  unzip -o /tmp/yazi.zip -d /tmp/yazi-bin
  sudo install /tmp/yazi-bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin
  rm -rf /tmp/yazi.zip /tmp/yazi-bin
else
  echo "yazi already installed"
fi

# Iosevka Term is not in the default Ubuntu repos — install via GitHub release
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

# antidote is not in any apt repo — install via git clone
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
