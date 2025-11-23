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

##############################################
# Environment / PATH configuration
##############################################
use std/util "path add"

path add "~/.local/bin"

# Homebrew
path add "/opt/homebrew/bin"

# Rust
$env.CARGO_HOME = $env.HOME | path join ".cargo"
path add ($env.CARGO_HOME | path join "bin")

# bob (neovim)
path add "~/.local/share/bob/nvim-bin"

# Bun
$env.BUN_INSTALL = $env.HOME | path join ".bun"
path add ($env.BUN_INSTALL | path join "bin")

##############################################
# Configurations
##############################################
$env.EDITOR = "nvim"
$env.config.buffer_editor = "nvim"

##############################################
# Commands
##############################################

def vimconf [] { cd ~/.config; nvim . }

##############################################
# Aliases
##############################################

alias vim = nvim

alias zj = zellij

alias oc = opencode

alias conf = /usr/bin/git --git-dir=($env.HOME | path join ".cfg") --work-tree=($env.HOME)

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
