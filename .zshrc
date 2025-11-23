export EDITOR=nvim
# source ~/.zsh/zsh-defer/zsh-defer.plugin.zsh

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/mysql/bin"

export STARSHIP_TERM=xterm-256color
# eval "$(starship init zsh)"

alias zj="zellij"

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias vim='nvim'
alias vimconf='(cd ~/.config && nvim .)'
alias ts='source ~/.local/scripts/tmux-sessionizer'

alias icat="kitten icat"

alias ga="git add -A"
alias gc="git commit -S"
alias gcm="git commit -S -m"
alias gco="git checkout"
alias gb="git branch"
alias gpf="git push --force-with-lease"

alias lg=lazygit

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias oc="opencode"

export PGDATA="/usr/local/var/postgres"

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

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# source <(fzf --zsh)

export PATH=$PATH:$HOME/.local/share/bob/nvim-bin

export PATH="$HOME/.asdf/shims:$PATH"
# append completions to fpath
fpath=(${ASDF_DIR}/completions ~/.stripe $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

for script in ~/.zsh/completions/*; do
  source $script
done

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Hook direnv
eval "$(direnv hook zsh)"

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

alias tf=terraform

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /opt/homebrew/bin/terraform terraform

export CONFLUENT_HOME=~/confluent-7.8.0
export PATH=$PATH:$CONFLUENT_HOME/bin

source ~/.aienv
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

eval "$(fnm env --use-on-cd --shell zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by sctl
export SHIPD_WORKSPACE="~/dev/shipd/main"
# BEGIN_AWS_SSO_CLI

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once in your shell.  Hence we do not include the two lines:
#
# autoload -Uz +X compinit && compinit
# autoload -Uz +X bashcompinit && bashcompinit
#
# If you do not already have these lines, you must COPY the lines 
# above, place it OUTSIDE of the BEGIN/END_AWS_SSO_CLI markers
# and of course uncomment it

__aws_sso_profile_complete() {
     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    _multi_parts : "($(/opt/homebrew/bin/aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -n "$AWS_PROFILE" ]; then
        echo "Unable to assume a role while AWS_PROFILE is set"
        return 1
    fi

    if [ -z "$1" ]; then
        echo "Usage: aws-sso-profile <profile>"
        return 1
    fi

    eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -p "$1")
    if [ "$AWS_SSO_PROFILE" != "$1" ]; then
        return 1
    fi
}

aws-sso-clear() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -z "$AWS_SSO_PROFILE" ]; then
        echo "AWS_SSO_PROFILE is not set"
        return 1
    fi
    eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -c)
}

compdef __aws_sso_profile_complete aws-sso-profile
complete -C /opt/homebrew/bin/aws-sso aws-sso

# END_AWS_SSO_CLI

# Added by Antigravity
export PATH="/Users/charley/.antigravity/antigravity/bin:$PATH"
