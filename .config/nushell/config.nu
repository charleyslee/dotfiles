# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
#
##############################################
# Basic configuration
##############################################
$env.config.show_banner = false

const NU_LIB_DIRS = [
  $nu.default-config-dir
]

##############################################
# Environment / PATH configuration
##############################################
use std/util "path add"

path add "/usr/local/bin"
path add "~/.local/bin"

# Homebrew (macOS only)
if (sys host | get name) == "Darwin" {
    path add "/opt/homebrew/bin"
}

# Rust
$env.CARGO_HOME = $env.HOME | path join ".cargo"
path add ($env.CARGO_HOME | path join "bin")

# bob (neovim)
path add "~/.local/share/bob/nvim-bin"

# fnm (node)
if (which fnm | is-not-empty) {
    fnm env --json | from json | load-env
    path add ($env.FNM_MULTISHELL_PATH | path join "bin")
}

# Bun
$env.BUN_INSTALL = $env.HOME | path join ".bun"
path add ($env.BUN_INSTALL | path join "bin")

# pnpm
if (sys host | get name) == "Darwin" {
    $env.PNPM_HOME = ($env.HOME | path join "Library" "pnpm")
} else {
    $env.PNPM_HOME = ($env.HOME | path join ".local/share/pnpm")
}
path add $env.PNPM_HOME

# OpenCode
path add ($env.HOME | path join ".opencode/bin")

# Google Cloud CLI
path add ($env.HOME | path join "google-cloud-sdk/bin")

##############################################
# Configurations
##############################################
$env.EDITOR = "nvim"
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"

##############################################
# Commands
##############################################

# def vimconf [] { cd ~/.config; nvim . }

##############################################
# Aliases
##############################################

alias vim = nvim

alias zj = zellij

alias oc = opencode

alias cfg = /usr/bin/git --git-dir=($env.HOME | path join ".cfg") --work-tree=($env.HOME)

alias ga = git add
alias gc = git commit
alias gco = git checkout
alias gpf = git push --force-with-lease

##############################################
# Completions
##############################################

# Load custom completions
use completions *

# External completers
use completers

$env.config.completions.external = {
    enable: true
    completer: {|spans| completers external $spans }
}

##############################################
# Other
##############################################

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

use direnv.nu
use mise.nu

$env.OPENCODE_EXPERIMENTAL_PLAN_MODE = 1
