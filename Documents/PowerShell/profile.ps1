# Customizes the prompt
function Prompt {
    $color = [char]27
    $gray = "${color}[22;37m"
    $blue = "${color}[1;34m"
    $purple = "${color}[1;35m"
    $resetColor = "${color}[00m"

    $path = switch -Wildcard ($executionContext.SessionState.Path.CurrentLocation.Path) {
        "${HOME}" { "~" }
        "${HOME}\*" { $executionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~").Replace("\","/") }
        default { $executionContext.SessionState.Path.CurrentLocation.Path.Replace("\","/") }
    }

    $branch = git branch --show-current
    $branchString = ""
    if ($branch) {
        $branchString = "${gray}:${purple}${branch}"
    }

    return "${blue}${path}${branchString}${gray}`$${resetColor} "
}

# Changes ls command to use ls from Git, using Linux style
if ($host.Name -eq 'ConsoleHost') {
    function Use-GitLS {
        & 'C:\Program Files\Git\usr\bin\ls' --color=auto $args
    }

    Set-Alias -Name "ls" -Value Use-GitLS -Option AllScope
}

# Configures auto-complete suggestions
Import-Module PSReadline
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# Disables the new argument passing from Powershell 7.3, to fix passing of empty ${args}
$PSNativeCommandArgumentPassing = "Legacy"

# Disables syntax highlighting
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

# Configures Fast Node Manager (fnm)
$Env:PATH += ";${HOME}\.fnm"
fnm env --use-on-cd | Out-String | Invoke-Expression

# Loads gadd command-line utility for git
$Env:PATH += ";${HOME}\dev\gadd\target\release"

# Shortcut for Docker
function dc { docker compose ${args} }

# Shortcuts for Jetbrains IDEs
function intellij { idea64 ${args} }
function rider { rider64 ${args} }

# Remove existing aliases to be overridden by our git shortcuts below
del alias:gc -force
del alias:gps -force

# Shortcuts for common git operations
function g { git ${args} }
function ga { git add ${args} }
function gai { git -c color.ui=always add -i ${args} }
function gb { git branch ${args} }
function gc { git commit ${args} }
function gca { git add . ; git commit ${args} }
function gch { git checkout ${args} }
function gchm { git checkout $(Get-MainGitBranch) }
function gd { git diff ${args} }
function glg { git log --oneline ${args} }
function gpl { git pull ${args} }
function gplom { git pull origin $(Get-MainGitBranch) }
function gps { git push ${args} }
function gpsu { git push -u origin $(Get-CurrentGitBranch) ${args} }
function grh { git reset --hard origin/$(Get-CurrentGitBranch) ${args} }
function gs { git -c color.ui=always status -sb ${args} | python "$HOME/util-scripts/sort-git-status.py" }

# Shortcuts for git management of dotfiles
function df-g { git --git-dir="$HOME/dotfiles" --work-tree="$HOME" ${args} }
function df-ga { df-g add ${args} }
function gai { df-g -c color.ui=always add -i ${args} }
function df-gb { df-g branch ${args} }
function df-gc { df-g commit ${args} }
function df-gd { df-g diff ${args} }
function df-glg { df-g log --oneline ${args} }
function df-gpl { df-g pull ${args} }
function df-gps { df-g push ${args} }
function df-gs { df-g -c color.ui=always status -sb ${args} | python "$HOME/util-scripts/sort-git-status.py" }
function df-ls { df-g ls-tree windows -r --name-only }

# Returns the current git branch
function Get-CurrentGitBranch { git branch --show-current }

# Returns main/master branch depending on repo
function Get-MainGitBranch {
    if ((git rev-parse --git-dir 2>$null) -eq $null) { return }

    $mainRefs = "refs/heads/main", "refs/remotes/origin/main"
    foreach ($ref in ${mainRefs}) {
        git show-ref -q --verify ${ref}
        if (${?}) {
            return "main"
        }
    }

    return "master"
}

# Enters Python virtual environment in provided path
function Venv {
    $venvPath = "venv\scripts\activate"
    if (${args}.Count -eq 0) {
        . .\${venvPath}
    } else {
        $targetDir = "$($args[0])"
        . .\${targetDir}\${venvPath}
    }
}

# Renames directory/file to kebab-case.
# Supports piping, so may for example be used to fix a whole directory: dir | Fix-ItemCase
function Fix-ItemCase {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $Item
    )

    process {
        $itemName = $Item.Name.ToLower()
        $itemName = $itemName.replace(" (1)", "")
        $itemName = $itemName.replace(" - ", "-")
        $itemName = $itemName.replace(" ", "-")
        $itemName = $itemName.replace("_", "-")
        $itemName = $itemName.replace("(", "")
        $itemName = $itemName.replace(")", "")
        $itemName = $itemName.replace("[", "")
        $itemName = $itemName.replace("]", "")
        $itemName = $itemName.replace("'", "")

        if ($itemName -cne $Item.Name) {
            Write-Output "$($Item.Name) -> ${itemName}"
            Rename-Item -LiteralPath $Item.FullName -NewName $itemName
        }
    }
}
