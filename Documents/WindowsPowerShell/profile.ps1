# Removes colorized command highlighting.
remove-module PSReadline

# Customizes the prompt.
function prompt {
    $color = [char]27

    $path = switch -Wildcard ($executionContext.SessionState.Path.CurrentLocation.Path) {
        "$HOME" { "~" }
        "$HOME\*" { $executionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~").Replace("\","/") }
        default { $executionContext.SessionState.Path.CurrentLocation.Path.Replace("\","/") }
    }

    $branch = git branch --show-current
    $branchString = ""
    if ($branch) {
        $branchString = "$color[37m:$color[1;35m$branch"
    }

    return "$color[1;34m$path$branchString$color[37m`$$color[00m "
}

# Utility function for handling dotfiles with Git.
function dotfiles {
    git --git-dir="$HOME/dotfiles" --work-tree="$HOME" $args
}

# Utility function for viewing dotfiles added to Git.
function dotfiles-ls {
    dotfiles ls-tree windows -r --name-only
}
