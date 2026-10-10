# fastfetch displays system info on shell startup; must run before p10k instant prompt.
# Skipped inside tmux panes and Neovim terminals.
[[ -z $TMUX && -z $NVIM ]] && fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Environment variables
export EDITOR=nvim
export EZA_ICONS_AUTO=1  # Show icons in eza output
typeset -U path; path=(~/.local/bin $path)  # User-installed tools

# Source antidote plugin manager (Homebrew on macOS, git clone to ~/.antidote on Linux)
if [[ $OSTYPE == darwin* ]]; then
  source ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote/antidote.zsh
else
  source ~/.antidote/antidote.zsh
fi

# Auto-update plugins weekly (interval in seconds; 604800 = 7 days)
zstyle ':antidote:bundle' use-cache true
zstyle ':antidote:plugin:*' update-interval 604800

# Initialize plugins statically with ~/.zsh_plugins.txt. The OMZ lib it loads also
# sets up history sharing, menu completion, and up/down prefix history search.
antidote load
unsetopt AUTO_CD  # OMZ lib enables this; conflicts with zoxide's fuzzy cd

# History (explicit HISTFILE: macOS /etc/zshrc defaults it to $ZDOTDIR)
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# Completion (compinit is deferred by use-omz; calling it here runs it now)
compinit
_comp_options+=(globdots)  # Include hidden files

# Aliases — replace standard tools with modern alternatives
alias vim='nvim'
alias lg='lazygit'
alias cat='bat'
alias ls='eza'
alias grep='rg'
alias find='fd'
alias top='btop'

# Pipe unified diff output through delta (preserves diff's exit status)
diff() { command diff -u "$@" | delta; return $pipestatus[1]; }

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--style full --preview 'if [ -d {} ]; then eza --tree --color=always {}; else bat --color=always {}; fi' $FZF_DEFAULT_OPTS"

# Functions

# zip-src [output-path.zip] — zip a git repo's tracked + untracked (non-ignored) files
# defaults to <repo-name>.zip in the current directory if no path is given
function zip-src {
    local repo_root
    repo_root="$(git rev-parse --show-toplevel)" || return 1
    local out=${1:-"$(basename "$repo_root").zip"}
    [[ $out = /* ]] || out="$PWD/$out"  # resolve relative paths against invocation cwd, not repo_root
    rm -f "$out"
    (cd "$repo_root" && git ls-files -co --exclude-standard | zip -q "$out" -@)
    echo "wrote $out"
}

# y — launch Yazi and cd into the directory on exit
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Shell integrations
eval "$(fzf --zsh)"                       # fzf key bindings and fuzzy completion
eval "$(zoxide init zsh --cmd cd)"        # zoxide: smarter cd with frecency
