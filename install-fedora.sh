#!/usr/bin/env bash

set -e

if [[ $EUID -eq 0 ]]; then
  echo "Run as your normal user, not root/sudo." >&2
  exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DNF_PACKAGES=(
  zsh
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
  ghostty
  wl-clipboard
  gcc-c++ libasan libubsan
)

# Enable COPR repos for packages not in the default Fedora repos
echo "Enabling COPR repos..."
sudo dnf copr enable -y atim/lazygit
sudo dnf copr enable -y scottames/ghostty

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

# neovim from GitHub releases: the Fedora package lags behind
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

# yazi from GitHub releases: the COPR build is stale and breaks yazi.nvim
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

# tree-sitter CLI from GitHub releases: needed by nvim-treesitter, distro packages lag
TS_VERSION="0.27.2"
TS_DIR="$HOME/.local/opt/tree-sitter-${TS_VERSION}"
if [[ ! -x "$TS_DIR/tree-sitter" ]]; then
  echo "Installing tree-sitter ${TS_VERSION}..."
  case "$(uname -m)" in
    aarch64) TS_ARCH="arm64" ;;
    *) TS_ARCH="x64" ;;
  esac
  mkdir -p "$TS_DIR" "$HOME/.local/bin"
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/v${TS_VERSION}/tree-sitter-linux-${TS_ARCH}.gz" \
    | gunzip > "$TS_DIR/tree-sitter"
  chmod +x "$TS_DIR/tree-sitter"
else
  echo "tree-sitter ${TS_VERSION} already installed at $TS_DIR"
fi
ln -sf "$TS_DIR/tree-sitter" "$HOME/.local/bin/tree-sitter"

if ! command -v claude &>/dev/null && [[ ! -x "$HOME/.local/bin/claude" ]]; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed"
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
