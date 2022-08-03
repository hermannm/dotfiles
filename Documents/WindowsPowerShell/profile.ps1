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

# Functions for common git operations.
function g { git $args }
function ga { git add $args }
function gb { git branch $args }
function gc { git commit $args }
function gca { git add . ; git commit $args }
function gch { git checkout $args }
function gchm { git checkout $(git-main-branch) }
function glg { git log --oneline $args }
function gpl { git pull $args }
function gplom { git pull origin $(git-main-branch) }
function gps { git push }
function gpsu { git push -u origin $(git-current-branch) $args }
function grh { git reset --hard origin/$(git-current-branch) }
function gs { git -c color.ui=always status -sb | python "$HOME/util-scripts/sort-git-status.py" }

# Functions for git management of dotfiles.
function df-g { git --git-dir="$HOME/dotfiles" --work-tree="$HOME" $args }
function df-ga { df-g add $args }
function df-gb { df-g branch $args }
function df-gc { df-g commit $args }
function df-glg { df-g log --oneline $args }
function df-gpl { df-g pull $args }
function df-gps { df-g push $args }
function df-gs { df-g -c color.ui=always status -sb | python "$HOME/util-scripts/sort-git-status.py" }
function df-ls { df-g ls-tree windows -r --name-only }

# Returns the current git branch.
function git-current-branch { git branch --show-current }

# Returns main/master branch depending on repo.
function git-main-branch {
    if ((git rev-parse --git-dir 2>$null) -eq $null) { return }

    $main_refs = "refs/heads/main", "refs/remotes/origin/main"
    foreach ($ref in $main_refs) {
        git show-ref -q --verify $ref
        if ($?) {
            return "main"
        }
    }

    return "master"
}
