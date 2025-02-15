; extends
((sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content)
 (#match? @_sigil_name "^G$")
 (#set! injection.language "graphql")
 (#set! injection.combined))

((sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content)
 (#match? @_sigil_name "^SQL$")
 (#set! injection.language "sql")
 (#set! injection.combined))
