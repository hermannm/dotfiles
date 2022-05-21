Remove-Module PSReadline

# Customizes the prompt.
function Prompt {
    $color = [char]27

    $path = switch -Wildcard ($executionContext.SessionState.Path.CurrentLocation.Path) {
        "$HOME" { "~" }
        "$HOME\*" { $executionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~").Replace("\","/") }
        default { $executionContext.SessionState.Path.CurrentLocation.Path.Replace("\","/") }
    }

    $branch = git branch --show-current
    $branchString = ""
    if ($branch) {
        $branchString = "$color[37m/$color[1;33m$branch"
    }

    return "$color[1;34m$path$branchString$color[37m: "
}

# Utility function for handling dotfiles with Git.
function dotfiles {
    git --git-dir="$HOME/dotfiles" --work-tree="$HOME" $args
}
