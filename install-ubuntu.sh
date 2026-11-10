#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APT_PACKAGES=(
  zsh
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
)

echo "Updating package index..."
sudo apt update

echo "Installing packages via apt..."
sudo apt install -y "${APT_PACKAGES[@]}"

# Ubuntu renames bat and fd
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd

# CPU arch for GitHub release downloads: amd64 or arm64
DEB_ARCH="$(dpkg --print-architecture)"

# fastfetch is not in the default Ubuntu repos — install via GitHub release
if ! command -v fastfetch &>/dev/null; then
  echo "Installing fastfetch..."
  FASTFETCH_VERSION="2.40.3"
  FASTFETCH_ARCH="$DEB_ARCH"
  [[ "$DEB_ARCH" == "arm64" ]] && FASTFETCH_ARCH="aarch64"
  curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-${FASTFETCH_ARCH}.deb" -o /tmp/fastfetch.deb
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
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${DEB_ARCH}.deb" -o /tmp/git-delta.deb
  sudo apt install -y /tmp/git-delta.deb
  rm /tmp/git-delta.deb
else
  echo "git-delta already installed"
fi

# lazygit is not in the default Ubuntu repos — install via GitHub release
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION="0.44.1"
  LAZYGIT_ARCH="x86_64"
  [[ "$DEB_ARCH" == "arm64" ]] && LAZYGIT_ARCH="arm64"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" -o /tmp/lazygit.tar.gz
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  rm /tmp/lazygit.tar.gz /tmp/lazygit
else
  echo "lazygit already installed"
fi

# neovim from GitHub releases: the Ubuntu package is far too old
NVIM_VERSION="0.12.6"
NVIM_DIR="$HOME/.local/opt/nvim-${NVIM_VERSION}"
if [[ ! -x "$NVIM_DIR/bin/nvim" ]]; then
  echo "Installing neovim ${NVIM_VERSION}..."
  case "$(uname -m)" in
    aarch64) NVIM_ARCH="arm64" ;;
    *) NVIM_ARCH="$(uname -m)" ;;
  esac
  mkdir -p "$NVIM_DIR" "$HOME/.local/bin"
  curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" \
    | tar -xz -C "$NVIM_DIR" --strip-components=1
else
  echo "neovim ${NVIM_VERSION} already installed at $NVIM_DIR"
fi
ln -sf "$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"

# yazi from GitHub releases: not in the Ubuntu repos, and old versions break yazi.nvim
YAZI_VERSION="26.9.1"
YAZI_DIR="$HOME/.local/opt/yazi-${YAZI_VERSION}"
if [[ ! -x "$YAZI_DIR/yazi" ]]; then
  echo "Installing yazi ${YAZI_VERSION}..."
  YAZI_PKG="yazi-$(uname -m)-unknown-linux-gnu"
  YAZI_TMP="$(mktemp -d)"
  curl -fsSL "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/${YAZI_PKG}.zip" -o "$YAZI_TMP/yazi.zip"
  unzip -q "$YAZI_TMP/yazi.zip" -d "$YAZI_TMP"
  mkdir -p "$YAZI_DIR" "$HOME/.local/bin"
  cp "$YAZI_TMP/$YAZI_PKG/yazi" "$YAZI_TMP/$YAZI_PKG/ya" "$YAZI_DIR/"
  rm -rf "$YAZI_TMP"
else
  echo "yazi ${YAZI_VERSION} already installed at $YAZI_DIR"
fi
ln -sf "$YAZI_DIR/yazi" "$HOME/.local/bin/yazi"
ln -sf "$YAZI_DIR/ya" "$HOME/.local/bin/ya"

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
