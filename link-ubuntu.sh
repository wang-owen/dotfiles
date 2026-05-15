#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---Packages---

APT_PACKAGES=(
  zsh
  neovim
  tmux
  git
  bat
  ripgrep
  fd-find
  fzf
  btop
)

echo "Updating package index..."
sudo apt update

echo "Installing packages via apt..."
sudo apt install -y "${APT_PACKAGES[@]}"

# Ubuntu renames these binaries to avoid conflicts; symlink to canonical names
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

# antidote is not in any apt repo — install via git clone
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
