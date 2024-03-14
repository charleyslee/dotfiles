EDITOR=nvim
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

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
[ -s "/Users/charley/.bun/_bun" ] && zsh-defer source "/Users/charley/.bun/_bun"

export PATH=$PATH:/Users/charley/.local/share/bob/nvim-bin

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh    
