# aws-sso CLI external completer using its built-in completion mechanism
export def complete [spans: list<string>] {
    let line = $spans | str join " "
    with-env { COMP_LINE: $line } {
        ^aws-sso
    }
    | lines
    | each { |c| { value: $c } }
}
