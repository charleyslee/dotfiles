# wt - Git Worktree Manager

# Show help for wt commands
export def wt [] {
    help wt
}

# Get repository name from git remote or directory name
def wt-get-repo-name [] {
    let remote = (do { git remote get-url origin } | complete)
    if $remote.exit_code == 0 {
        $remote.stdout | str trim | path basename | str replace '.git' ''
    } else {
        # Fallback to directory name of git root
        git rev-parse --show-toplevel | str trim | path basename
    }
}

# Detect the main branch name (main or master)
def wt-get-main-branch [] {
    let branches = (git branch -l main master | lines | str trim | str replace '* ' '')
    if ('main' in $branches) {
        'main'
    } else if ('master' in $branches) {
        'master'
    } else {
        'main' # default assumption
    }
}

# Parse git worktree list --porcelain into structured data
def wt-list [] {
    let result = (do { git worktree list --porcelain } | complete)
    if $result.exit_code != 0 {
        return []
    }

    let output = ($result.stdout | str trim)
    if ($output | is-empty) {
        return []
    }

    $output
    | split row "\n\n"
    | where { $in != '' }
    | each { |entry|
        let lines = ($entry | lines)
        let path_line = ($lines | where { $in starts-with 'worktree ' } | get 0?)
        let head_line = ($lines | where { $in starts-with 'HEAD ' } | get 0?)
        let branch_line = ($lines | where { $in starts-with 'branch ' } | get 0?)
        let bare = ('bare' in $lines)

        {
            path: ($path_line | default '' | str replace 'worktree ' '')
            head: ($head_line | default '' | str replace 'HEAD ' '' | str substring 0..7)
            branch: ($branch_line | default '' | str replace 'branch refs/heads/' '')
            bare: $bare
        }
    }
    | where { $in.path != '' }
}

# Find worktree by branch name
def wt-find-worktree [branch: string] {
    wt-list | where { $in.branch == $branch } | get 0?
}

# Check if a branch is the main branch
def wt-is-main-branch [branch: string] {
    let main = (wt-get-main-branch)
    $branch == $main or $branch == 'main' or $branch == 'master'
}

# Get current worktree info
def wt-current [] {
    let cwd = (pwd | path expand)
    wt-list | where { $cwd starts-with $in.path } | get 0?
}

# Sanitize branch name for directory (replace / with -)
def wt-sanitize-branch [branch: string] {
    $branch | str replace --all '/' '-'
}

# Completer for worktree branch names
def wt-complete-branches [] {
    wt-list | get branch | where { $in != '' }
}

# Get the main worktree path (the original repo, not a linked worktree)
def wt-get-main-path [] {
    let git_dir = (do { git rev-parse --git-dir } | complete)
    if $git_dir.exit_code == 0 {
        let dir = ($git_dir.stdout | str trim)
        # If we're in a linked worktree, git-dir will be like /path/to/main/.git/worktrees/branch
        # If we're in main worktree, it will be just .git or /path/to/main/.git
        if ($dir | str contains '/worktrees/') {
            # Extract main repo path from .git/worktrees/xxx
            $dir | str replace --regex '/\.git/worktrees/.*$' ''
        } else {
            # We're in main worktree
            git rev-parse --show-toplevel | str trim
        }
    } else {
        ''
    }
}

# Run setup commands from .cursor/worktrees.json
def wt-run-setup [worktree_path: string] {
    let main_path = (wt-get-main-path)
    let config_path = ($main_path | path join '.cursor' 'worktrees.json')

    if not ($config_path | path exists) {
        return
    }

    print "Running worktree setup..."
    let config = (open $config_path)
    let setup = ($config | get -o 'setup-worktree')

    if $setup == null {
        return
    }

    if ($setup | describe | str starts-with 'list') {
        # It's an array of commands (run as bash with ROOT_WORKTREE_PATH set)
        for cmd in $setup {
            print $"  > ($cmd)"
            with-env { ROOT_WORKTREE_PATH: $main_path } { bash -c $cmd }
        }
    } else if ($setup | describe | str starts-with 'string') {
        # It's a script path relative to .cursor/
        let script_path = ($main_path | path join '.cursor' $setup)
        if ($script_path | path exists) {
            print $"  > Running ($setup)"
            with-env { ROOT_WORKTREE_PATH: $main_path } { bash $script_path }
        } else {
            print $"  Warning: Setup script not found: ($script_path)"
        }
    }

    print "Setup complete"
}

# Create a new worktree
export def --env "wt new" [
    branch: string           # Branch name for the worktree
    --base: string = ''      # Base ref to branch from (default: origin/main)
] {
    # Fetch latest
    print "Fetching latest..."
    git fetch origin

    let repo_name = (wt-get-repo-name)
    let main_branch = (wt-get-main-branch)
    let base_ref = if $base == '' { $"origin/($main_branch)" } else { $base }
    let sanitized = (wt-sanitize-branch $branch)
    let worktree_path = (git rev-parse --show-toplevel | str trim | path dirname | path join $"($repo_name)-($sanitized)")

    # Check if worktree already exists
    let existing = (wt-find-worktree $branch)
    if $existing != null {
        print $"Worktree for '($branch)' already exists at ($existing.path)"
        cd $existing.path
        return
    }

    # Check if branch exists locally or on remote
    let local_exists = (do { git show-ref --verify --quiet $"refs/heads/($branch)" } | complete).exit_code == 0
    let remote_exists = (do { git show-ref --verify --quiet $"refs/remotes/origin/($branch)" } | complete).exit_code == 0

    if $local_exists {
        print $"Using existing local branch '($branch)'"
        git worktree add $worktree_path $branch
    } else if $remote_exists {
        print $"Using existing remote branch 'origin/($branch)'"
        git worktree add $worktree_path $branch
    } else {
        print $"Creating new branch '($branch)' from ($base_ref)"
        git worktree add --no-track -b $branch $worktree_path $base_ref
    }

    print $"Created worktree at ($worktree_path)"
    cd $worktree_path

    # Run setup commands if .cursor/worktrees.json exists
    wt-run-setup $worktree_path
}

# Switch to a worktree (auto-creates if missing)
export def --env "wt cd" [
    branch: string@wt-complete-branches  # Branch name to switch to
] {
    let worktree = (wt-find-worktree $branch)
    if $worktree != null {
        cd $worktree.path
    } else {
        print $"No worktree for '($branch)', creating one..."
        wt new $branch
    }
}

# List all worktrees
export def "wt ls" [] {
    let current_path = (pwd | path expand)
    wt-list | each { |wt|
        let is_current = ($current_path starts-with $wt.path)
        {
            current: (if $is_current { '*' } else { '' })
            branch: $wt.branch
            path: $wt.path
            head: $wt.head
        }
    }
}

# Remove a worktree
export def --env "wt rm" [
    branch?: string@wt-complete-branches  # Branch name to remove (default: current worktree)
    --all                                  # Remove all worktrees except main
] {
    if $all {
        let main_branch = (wt-get-main-branch)
        let worktrees = (wt-list | where { not (wt-is-main-branch $in.branch) and $in.branch != '' })

        if ($worktrees | is-empty) {
            print "No worktrees to remove"
            return
        }

        print $"Removing ($worktrees | length) worktree\(s\)..."
        $worktrees | par-each { |wt|
            print $"Removing ($wt.branch)..."
            git worktree remove $wt.path --force
            print $"Removed worktree for '($wt.branch)'"
        }
        print "Done"
        return
    }

    # Determine which branch to remove
    let target_branch = if $branch == null {
        let current = (wt-current)
        if $current == null {
            print "Error: Not in a worktree"
            return
        }
        $current.branch
    } else {
        $branch
    }

    # Guard: don't remove main
    if (wt-is-main-branch $target_branch) {
        print $"Error: Cannot remove main worktree \(($target_branch)\)"
        return
    }

    let worktree = (wt-find-worktree $target_branch)
    if $worktree == null {
        print $"Error: No worktree found for branch '($target_branch)'"
        return
    }

    # If we're in the worktree being removed, cd out first
    let current_path = (pwd | path expand)
    if ($current_path starts-with $worktree.path) {
        let main_wt = (wt-find-worktree (wt-get-main-branch))
        if $main_wt != null {
            print $"Switching to main worktree first..."
            cd $main_wt.path
        }
    }

    print $"Removing worktree for '($target_branch)'..."
    git worktree remove $worktree.path
    print "Done"
}
