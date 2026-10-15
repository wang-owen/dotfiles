# Dotfiles

Personal configuration files for macOS and Linux.

## What's included

| Directory | Config for |
|-----------|-----------|
| `zsh/` | Zsh (`.zshrc`, `.zprofile`, Powerlevel10k, plugins) |
| `nvim/` | Neovim |
| `tmux/` | tmux |
| `ghostty/` | Ghostty terminal |
| `yazi/` | Yazi file manager |
| `fastfetch/` | Fastfetch system info |
| `btop/` | btop system monitor |
| `git/` | Git (`.gitconfig`, global ignore) |
| `lazygit/` | lazygit |
| `clangd/` | clangd (LSP config) |
| `cp/` | Competitive programming templates |
| `aerospace/` | AeroSpace window manager (macOS) |
| `claude/` | Claude Code settings and status line |

## Setup

### 1. Clone the repo

```sh
git clone https://github.com/wang-owen/dotfiles.git ~/dotfiles
```

On macOS, the first `git` call prompts to install the Xcode Command Line Tools.

### 2. Run the install script

```sh
bash ~/dotfiles/install-macos.sh   # or install-arch.sh / install-fedora.sh / install-ubuntu.sh
```

Each script installs packages (macOS: Homebrew and the `Brewfile`), sets zsh as the login shell on Linux, and runs `link.sh` to symlink configs into place, overwriting existing files. To only relink, run `bash ~/dotfiles/link.sh`.

### 3. Manual steps

- Install the [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts) font and set it in your terminal.
- For LaTeX, install a TeX distribution (provides `latexmk`).
- For competitive programming, install the [Competitive Companion](https://github.com/jmerle/competitive-companion) browser extension.

### 4. Reload Zsh

```sh
exec zsh
```

Antidote will install plugins on first launch based on `.zsh_plugins.txt`.

## Notes

- Neovim plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and will be installed automatically on first launch.
- Language servers and formatters are installed automatically by Mason on first launch, except `rustfmt` and `rust-analyzer`, which come from `rustup`.
- Competitive programming: in Neovim, `<leader>c` (see which-key) receives contests/problems from Competitive Companion into `~/Developer/cp` and builds/runs samples.
