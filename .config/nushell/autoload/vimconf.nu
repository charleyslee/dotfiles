def "nu-complete config-dirs" [] {
  ls ~/.config | where type == dir | get name | path basename
}

def vimconf [subdir?: string@"nu-complete config-dirs"] {
  let target = if ($subdir | is-empty) {
    ls ~/.config | where type == dir | get name | path basename | to text | fzf
  } else {
    $subdir
  }
  if ($target | is-empty) { return }
  cd ($"~/.config/($target)" | path expand); nvim .
}
