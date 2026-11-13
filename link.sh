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
link "tmux/sessions.sh" "$HOME/.config/tmux/sessions.sh"

# TPM and tmux plugins, installed via a throwaway tmux server
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  echo "Cloning tpm..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
missing_plugin=false
for plugin in $(sed -n "s/^set -g @plugin '\(.*\)'/\1/p" "$DOTFILES/tmux/tmux.conf"); do
  [[ -d "$HOME/.tmux/plugins/${plugin##*/}" ]] || missing_plugin=true
done
if $missing_plugin && command -v tmux &>/dev/null; then
  echo "Installing tmux plugins..."
  tmux -L tpm-install -f "$HOME/.tmux.conf" new-session -d
  TMUX="$(tmux -L tpm-install display -p '#{socket_path}'),0,0" "$TPM_DIR/bin/install_plugins"
  tmux -L tpm-install kill-server
  # load new plugins into a running server
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
fi

# git
link "git/gitconfig" "$HOME/.gitconfig"
link "git/ignore"    "$HOME/.config/git/ignore"

# claude code
link "claude/settings.json"         "$HOME/.claude/settings.json"
link "claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# competitive programming
for f in template.cc dbg.h compile_flags.txt; do
  link "cp/$f" "$HOME/Developer/cp/$f"
done

if [[ "$(uname)" == "Darwin" ]]; then
  link "aerospace"          "$HOME/.config/aerospace"
  link "clangd/config.yaml" "$HOME/Library/Preferences/clangd/config.yaml"
else
  link "clangd/config.yaml" "$HOME/.config/clangd/config.yaml"
  link "sway"               "$HOME/.config/sway"
  link "waybar"             "$HOME/.config/waybar"
  link "fuzzel"             "$HOME/.config/fuzzel"
  link "mako"               "$HOME/.config/mako"
  link "gtklock"            "$HOME/.config/gtklock"
  link "ghostty/linux"      "$HOME/.config/ghostty-linux"
  link "theme/theme-switch"         "$HOME/.local/bin/theme-switch"
  link "theme/theme-switch.service" "$HOME/.config/systemd/user/theme-switch.service"
  link "theme/theme-switch.timer"   "$HOME/.config/systemd/user/theme-switch.timer"
  systemctl --user daemon-reload
  systemctl --user enable --now theme-switch.timer
  # GNOME Settings won't start outside GNOME
  link "applications/org.gnome.Settings.desktop" "$HOME/.local/share/applications/org.gnome.Settings.desktop"
fi

echo "Done. Restart your shell or run: exec zsh"
