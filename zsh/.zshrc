# Must run before the p10k instant prompt
[[ -z $TMUX && -z $NVIM ]] && fastfetch

# p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Environment variables
export EDITOR=nvim
export EZA_ICONS_AUTO=1
typeset -U path; path=(~/.local/bin $path)

# Plugins
if [[ $OSTYPE == darwin* ]]; then
  source ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote/antidote.zsh
else
  source ~/.antidote/antidote.zsh
fi

zstyle ':antidote:bundle' use-cache true
zstyle ':antidote:plugin:*' update-interval 604800

antidote load
unsetopt AUTO_CD  # conflicts with zoxide

# History (macOS /etc/zshrc defaults HISTFILE to $ZDOTDIR)
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# Completion (use-omz defers compinit; run it now)
compinit
_comp_options+=(globdots)

# Aliases
alias vim='nvim'
alias lg='lazygit'
alias cat='bat'
alias ls='eza'
alias grep='rg'
alias find='fd'
alias top='btop'

diff() { command diff -u "$@" | delta; return $pipestatus[1]; }

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--style full --preview 'if [ -d {} ]; then eza --tree --color=always {}; else bat --color=always {}; fi' $FZF_DEFAULT_OPTS"

# Functions

# zip-src [out.zip]: zip tracked and untracked non-ignored files
function zip-src {
    local repo_root
    repo_root="$(git rev-parse --show-toplevel)" || return 1
    local out=${1:-"$(basename "$repo_root").zip"}
    [[ $out = /* ]] || out="$PWD/$out"
    rm -f "$out"
    (cd "$repo_root" && git ls-files -co --exclude-standard | zip -q "$out" -@)
    echo "wrote $out"
}

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"
