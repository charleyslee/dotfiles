# GT (Graphite) completions
export def complete [spans: list<string>] {
    let current = ($spans | last)
    let current_trimmed = ($current | str trim)
    
    let clean_spans = ($spans | where { ($in | str trim) != "" })
    
    if ($clean_spans | is-empty) {
        return null
    }
    
    let is_flag = ($current_trimmed | str starts-with "-")
    
    # For flags: pass everything to yargs (it needs the -- to know we want flags)
    # For commands: drop the partial, yargs doesn't filter partials well
    let yargs_spans = if $is_flag {
        $clean_spans
    } else if $current_trimmed == "" {
        $clean_spans
    } else {
        $clean_spans | drop nth (($clean_spans | length) - 1)
    }
    
    let comp_cword = if $current_trimmed == "" {
        ($yargs_spans | length)
    } else if $is_flag {
        (($yargs_spans | length) - 1)
    } else {
        ($yargs_spans | length)
    }
    
    let comp_line = ($yargs_spans | str join " ")
    let comp_point = ($comp_line | str length)
    
    try {
        with-env {
            COMP_CWORD: ($comp_cword | into string)
            COMP_LINE: $comp_line
            COMP_POINT: ($comp_point | into string)
        } {
            ^gt --get-yargs-completions ...$yargs_spans
            | lines
            | where { |line| 
                if ($line | str contains ":") {
                    let value = ($line | split column ":" | get column1.0)
                    ($value | str trim | is-not-empty) and (not ($value | str contains " "))
                } else {
                    ($line | str starts-with "-")
                }
            }
            | each { |line|
                let trimmed = ($line | str trim)
                if ($trimmed | str contains ":") {
                    let parts = ($trimmed | split column ":" --number 2)
                    { 
                        value: ($parts.column1.0 | str trim), 
                        description: ($parts.column2.0? | default "" | str trim) 
                    }
                } else {
                    { value: $trimmed }
                }
            }
            | where { |row|
                # Always filter by prefix (yargs doesn't filter reliably)
                if $current_trimmed == "" {
                    true
                } else {
                    $row.value | str downcase | str starts-with ($current_trimmed | str downcase)
                }
            }
        }
    } catch {
        null
    }
}
