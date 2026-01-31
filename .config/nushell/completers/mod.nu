# Route commands to their completers
const FISH_COMMANDS = [nu, git, asdf]

export def external [spans: list<string>] {
    use gt.nu
    use fish.nu
    use carapace.nu
    use aws-sso.nu

    # Expand aliases
    let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    let cmd = $spans.0

    if $cmd == "gt" {
        gt complete $spans
    } else if $cmd == "aws-sso" {
        aws-sso complete $spans
    } else if $cmd in $FISH_COMMANDS {
        fish complete $spans
    } else {
        carapace complete $spans
    }
}
