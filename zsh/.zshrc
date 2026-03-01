fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# vi mode
bindkey -v
export KEYTIMEOUT=1

# History substring search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search   # Up arrow binding
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down arrow binding

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files

# copydir command (copies path to current working directory)
function copydir {
  pwd | tr -d "\r\n" | pbcopy
}

# fzf config
export FZF_DEFAULT_OPTS="--style full --preview='bat --color=always {}' $FZF_DEFAULT_OPTS"

# C++
export SDKROOT=$(xcrun --show-sdk-path)
export CPLUS_INCLUDE_PATH="$SDKROOT/usr/include/c++/v1"
clang++() {
    command clang++ -std=c++20 "$@"
}
g++() {
    command g++ -std=c++20 "$@"
}

# Aliases
alias vim='nvim'
alias cat='bat'
alias ls='eza --icons'
alias grep='rg'
alias find='fd'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh --cmd cd)"

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh
