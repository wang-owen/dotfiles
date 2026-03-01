# Dotfiles

Personal configuration files for macOS.

## What's included

| Directory | Config for |
|-----------|-----------|
| `zsh/` | Zsh (`.zshrc`, Powerlevel10k, plugins) |
| `nvim/` | Neovim |
| `tmux/` | tmux |
| `ghostty/` | Ghostty terminal |
| `yazi/` | Yazi file manager |
| `fastfetch/` | Fastfetch system info |
| `git/` | Git (`.gitconfig`) |
| `lazygit/` | lazygit |
| `clangd/` | clangd (LSP config) |

## Setup

### 1. Install dependencies

Install [Homebrew](https://brew.sh), then install the required tools:

```sh
brew install zsh antidote fastfetch fzf zoxide yazi bat eza ripgrep fd btop git git-delta neovim tmux lazygit stylua prettierd black tex-fmt clangd pyright rust-analyzer typescript-language-server lua-language-server latexmk
```

For LaTeX PDF preview on macOS, also install [Skim](https://skim-app.sourceforge.io).

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

This creates symlinks from the standard config locations to the files in this repo. Existing files at those paths will be overwritten.

### 4. Reload Zsh

```sh
exec zsh
```

Antidote will install plugins on first launch based on `.zsh_plugins.txt`.

## Notes

- Neovim plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and will be installed automatically on first launch.
- `rustfmt` and `rust-analyzer` are best installed via `rustup` rather than Homebrew.
