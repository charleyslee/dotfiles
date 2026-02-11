# AWS SSO CLI completions and helper commands for Nushell

# Completion function for AWS SSO profiles
def "nu-complete aws-sso-profiles" [] {
    ^aws-sso -L error list --csv Profile
    | lines
    | each { |p| { value: $p, description: "AWS SSO Profile" } }
}

# Assume an AWS SSO role by profile name
export def --env aws-sso-profile [
    profile: string@"nu-complete aws-sso-profiles"  # Profile name to assume
] {
    if ($env.AWS_PROFILE? | is-not-empty) {
        error make { msg: "Unable to assume a role while AWS_PROFILE is set" }
    }

    # Get credentials from aws-sso eval and parse them
    let output = ^aws-sso -L error eval -p $profile

    # Parse the export statements and set env vars
    for line in ($output | lines) {
        let parts = $line | parse "export {name}={value}"
        if ($parts | is-not-empty) {
            let name = $parts.0.name
            let value = $parts.0.value | str trim --char '"'
            load-env { $name: $value }
        }
    }
}

# Clear current AWS SSO session credentials
export def --env aws-sso-clear [] {
    if ($env.AWS_SSO_PROFILE? | is-empty) {
        error make { msg: "AWS_SSO_PROFILE is not set" }
    }

    let output = ^aws-sso -L error eval -c

    for line in ($output | lines) {
        let parts = $line | parse "unset {name}"
        if ($parts | is-not-empty) {
            hide-env $parts.0.name
        }
    }
}

# Show current AWS SSO profile
export def aws-sso-whoami [] {
    if ($env.AWS_SSO_PROFILE? | is-empty) {
        print "No AWS SSO profile active"
    } else {
        print $"Profile: ($env.AWS_SSO_PROFILE)"
        if ($env.AWS_SSO_ACCOUNT_ID? | is-not-empty) {
            print $"Account: ($env.AWS_SSO_ACCOUNT_ID)"
        }
        if ($env.AWS_SSO_ROLE_NAME? | is-not-empty) {
            print $"Role: ($env.AWS_SSO_ROLE_NAME)"
        }
        ^aws-sso -L error time
    }
}
