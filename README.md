# Dotfiles

Personal configuration files for macOS (and Linux via `install-fedora.sh` / `install-ubuntu.sh`).

## What's included

| Directory | Config for |
|-----------|-----------|
| `zsh/` | Zsh (`.zshrc`, `.zprofile`, Powerlevel10k, plugins) |
| `nvim/` | Neovim |
| `tmux/` | tmux |
| `ghostty/` | Ghostty terminal |
| `yazi/` | Yazi file manager |
| `fastfetch/` | Fastfetch system info |
| `git/` | Git (`.gitconfig`, global ignore) |
| `lazygit/` | lazygit |
| `clangd/` | clangd (LSP config) |
| `aerospace/` | AeroSpace window manager (macOS) |
| `claude/` | Claude Code settings and status line |

## Setup

### 1. Install dependencies

Install [Homebrew](https://brew.sh), then install the required tools:

```sh
brew install zsh antidote fastfetch fzf zoxide yazi bat eza ripgrep fd btop git git-delta neovim tmux lazygit tex-fmt
brew install --cask ghostty nikitabobko/tap/aerospace
```

For LaTeX, install a TeX distribution (provides `latexmk`) and [Skim](https://skim-app.sourceforge.io) for PDF preview.

For the Zsh prompt, install the [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts) font and set it in your terminal.

### 2. Clone the repo

```sh
git clone https://github.com/wang-owen/dotfiles.git ~/dotfiles
```

### 3. Symlink configs

```sh
cd ~/dotfiles
bash link.sh
```

This creates symlinks from the standard config locations to the files in this repo. Existing files at those paths will be overwritten. On Linux, run `bash install-fedora.sh` or `bash install-ubuntu.sh` instead; they install packages and then run `link.sh`.

### 4. Reload Zsh

```sh
exec zsh
```

Antidote will install plugins on first launch based on `.zsh_plugins.txt`.

## Notes

- Neovim plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and will be installed automatically on first launch.
- Language servers and formatters are installed automatically by Mason on first launch, except `rustfmt` and `rust-analyzer`, which come from `rustup`.
