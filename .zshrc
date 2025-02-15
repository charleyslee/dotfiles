EDITOR=nvim
source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/mysql/bin"

eval "$(starship init zsh)"

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias vim='nvim'
alias vimconf='(cd ~/.config/nvim && nvim .)'
alias kconf='(cd ~/.config/kitty && nvim kitty.conf)'
alias ts='source ~/.local/scripts/tmux-sessionizer'

alias icat="kitten icat"

alias ga="git add -A"
alias gc="git commit -S"
alias gcm="git commit -S -m"
alias gco="git checkout"
alias gpf="git push --force-with-lease"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

function scrap() {
  local dir=~/dev/scrap/$(date +"%Y%m%d_%H%M%S")
  mkdir -p "$dir"
  cd "$dir"
}

function venv() {
    if [ ! -d ".venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv .venv
    fi
    source .venv/bin/activate
}

# bun completions
# [ -s "/Users/charley/.bun/_bun" ] && zsh-defer source "/Users/charley/.bun/_bun"
export HOMEBREW_NO_AUTO_UPDATE=1


export PATH=$PATH:$HOM/.local/share/bob/nvim-bin

. "$HOME/.asdf/asdf.sh"
export PATH="$HOME/.asdf/shims:$PATH"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

. ~/.asdf/plugins/golang/set-env.zsh

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(pyenv init -)"

for script in ~/.zsh/completions/*; do
    zsh-defer source $script
done

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh    

# Hook direnv
eval "$(direnv hook zsh)"

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

alias tf=terraform

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export CONFLUENT_HOME=~/confluent-7.8.0
export PATH=$PATH:$CONFLUENT_HOME/bin
