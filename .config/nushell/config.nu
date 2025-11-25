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

# fnm (node)
path add ($env.HOME | path join ".local/state/fnm_multishells/82230_1763954763762/bin")
$env.FNM_MULTISHELL_PATH = "/Users/charley/.local/state/fnm_multishells/82230_1763954763762"
$env.FNM_VERSION_FILE_STRATEGY = "local"
$env.FNM_DIR = "/Users/charley/.local/share/fnm"
$env.FNM_LOGLEVEL = "info"
$env.FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$env.FNM_COREPACK_ENABLED = "false"
$env.FNM_RESOLVE_ENGINES = "true"
$env.FNM_ARCH = "arm64"

# Bun
$env.BUN_INSTALL = $env.HOME | path join ".bun"
path add ($env.BUN_INSTALL | path join "bin")

# pnpm
$env.PNPM_HOME = $env.HOME | path join "Library" "pnpm"
path add $env.PNPM_HOME

##############################################
# Configurations
##############################################
$env.EDITOR = "nvim"
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"

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

alias cfg = /usr/bin/git --git-dir=($env.HOME | path join ".cfg") --work-tree=($env.HOME)

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Custom completion function for gt command
def "nu-complete gt" [context: string, position: int] {
    let spans = ($context | split words)
    # Calculate current word index (0-based, like bash/zsh COMP_CWORD)
    let comp_cword = (($spans | length) - 1 | into string)
    
    try {
        # Set environment variables that yargs expects
        with-env {
            COMP_CWORD: $comp_cword
            COMP_LINE: $context
            COMP_POINT: ($position | into string)
        } {
            # Call gt with the command line arguments
            ^gt --get-yargs-completions ...$spans
            | lines
            | where { |line| ($line | is-not-empty) }
            | each { |line|
                # Parse yargs format: "value:description"
                if ($line | str contains ":") {
                    let parts = ($line | split column ":" value description)
                    { value: $parts.value.0, description: $parts.description.0 }
                } else {
                    { value: $line }
                }
            }
        }
    } catch {
        # Return empty list on error (falls back to file completion)
        []
    }
}

# Define the gt extern with completion
export extern gt [
    ...args: string@"nu-complete gt"
]

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    # ...
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
    # ...
}

# direnv
$env.config.hooks.pre_prompt = [{ ||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
    # Direnv outputs $PATH as a string, but nushell silently breaks if isn't a list-like table.
    # The following behemoth of Nu code turns this into nu's format while following the standards of how to handle quotes, use it if you need quote handling instead of the line below it:
    # $env.PATH = $env.PATH | parse --regex ('' + `((?:(?:"(?:(?:\\[\\"])|.)*?")|(?:'.*?')|[^` + (char env_sep) + `]*)*)`) | each {|x| $x.capture0 | parse --regex `(?:"((?:(?:\\"|.))*?)")|(?:'(.*?)')|([^'"]*)` | each {|y| if ($y.capture0 != "") { $y.capture0 | str replace -ar `\\([\\"])` `$1` } else if ($y.capture1 != "") { $y.capture1 } else $y.capture2 } | str join }
    $env.PATH = $env.PATH | split row (char env_sep)
}]
