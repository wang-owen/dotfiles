# fastfetch displays system info on shell startup; must run before p10k instant prompt
fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh

# Environment variables
export EDITOR=nvim
export EZA_ICONS_AUTO=1  # Show icons in eza output

# Source antidote plugin manager
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory        # Append to history file instead of overwriting
setopt sharehistory         # Share history across all sessions
setopt hist_ignore_space    # Don't save commands prefixed with a space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# History substring search — use up/down arrows to search history by prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search   # Up arrow binding
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down arrow binding

# Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files

# Aliases — replace standard tools with modern alternatives
alias vim='nvim'
alias cat='bat'
alias ls='eza'
alias grep='rg'
alias find='fd'
alias top='btop'

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--style full --preview 'if [ -d {} ]; then tree -C {}; else bat --color=always {}; fi' $FZF_DEFAULT_OPTS"

# Functions

# copydir — copy the current working directory path to clipboard
function copydir {
  pwd | tr -d "\r\n" | pbcopy
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
