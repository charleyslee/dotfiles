# History
const ctrl_r = {
  name: history_menu
  modifier: control
  keycode: char_r
  mode: [emacs, vi_insert, vi_normal]
  event: [
    {
      send: executehostcommand
      cmd: "
      let result = history
        | reverse
        | get command
        | str replace --all (char newline) ' '
        | to text
        | fzf --height 40% --reverse --border;
      commandline edit --append $result;
      commandline set-cursor --end
      "
    }
  ]
}

# Update the $env.config
export-env {
  # Only append if not already present (check by name)
  let has_history_menu = $env.config.keybindings | any {|kb| $kb.name == "history_menu"}
  
  if not $has_history_menu {
    $env.config.keybindings = $env.config.keybindings | append [
      $ctrl_r
    ]
  }
}
