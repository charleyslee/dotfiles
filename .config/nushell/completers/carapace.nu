# Carapace-based completions (default fallback)
export def complete [spans: list<string>] {
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}
