# Customizes the prompt.
function prompt {
    $color = [char]27
    $gray = "${color}[22;37m"
    $blue = "${color}[1;34m"
    $purple = "${color}[1;35m"
    $default = "${color}[00m"

    $path = switch -Wildcard ($executionContext.SessionState.Path.CurrentLocation.Path) {
        "$HOME" { "~" }
        "$HOME\*" { $executionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~").Replace("\","/") }
        default { $executionContext.SessionState.Path.CurrentLocation.Path.Replace("\","/") }
    }

    $branch = git branch --show-current
    $branchString = ""
    if ($branch) {
        $branchString = "${gray}:${purple}${branch}"
    }

    return "${blue}${path}${branchString}${gray}`$${default} "
}

# Configures auto-complete suggestions.
import-module PSReadline
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History

# Disables syntax highlighting.
Set-PSReadlineOption -Colors @{
    ContinuationPrompt = "white"
    Emphasis = "white"
    Error = "white"
    Selection = "white"
    Default = "white"
    Comment = "white"
    Keyword = "white"
    String = "white"
    Operator = "white"
    Variable = "white"
    Command = "white"
    Parameter = "white"
    Type = "white"
    Number = "white"
    Member = "white"
    InlinePrediction = "gray"
}

# Alias for opening PowerShell profile (not using $profile, since that is in a different path).
$global:psprofile = "${HOME}\Documents\WindowsPowerShell\profile.ps1"

# Shortcut for Docker.
function dc { docker compose $args }

# Shortcuts for Jetbrains IDEs.
function rider { rider64 $args }
function idea { idea64 $args }

# Remove existing aliases to be overridden by our git shortcuts below.
del alias:gc -force
del alias:gps -force

# Shortcuts for common git operations.
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

# Shortcuts for git management of dotfiles.
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

# Enters Python virtual environment in provided path.
function venv {
    $venv_path = "venv\scripts\activate"
    if ( $args.Count -eq 0 ) {
        . .\$venv_path
    } else {
        $target_dir = "$($args[0])"
        . .\$target_dir\$venv_path
    }
}

$env:DJANGO_READ_DOT_ENV_FILE = "true"
