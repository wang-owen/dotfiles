[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -d $HOMEBREW_PREFIX/opt/python@3/libexec/bin ]] && path=($HOMEBREW_PREFIX/opt/python@3/libexec/bin $path)

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
