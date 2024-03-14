EDITOR=nvim

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/charley/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/charley/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/charley/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/charley/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Homebrew setup
if [[ $(uname -m) == 'arm64' ]]; then
    BREWPATH=/opt/homebrew/bin
else
    BREWPATH=/usr/local/bin
fi
export PATH=$BREWPATH:$PATH

eval "$(starship init zsh)"

alias config='/usr/bin/git --git-dir=/Users/charley/.cfg/ --work-tree=/Users/charley'
alias vim='nvim'
alias vimconf='(cd ~/.config/nvim && nvim .)'
alias kconf='(cd ~/.config/kitty && nvim kitty.conf)'
alias ts='source ~/.local/scripts/tmux-sessionizer'

alias icat="kitten icat"

# bun completions
[ -s "/Users/charley/.bun/_bun" ] && source "/Users/charley/.bun/_bun"

export PATH=$PATH:/Users/charley/.local/share/bob/nvim-bin

