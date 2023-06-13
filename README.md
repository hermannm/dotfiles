# dotfiles

hermannm's config files for various developer tools.

## Usage

Clone as a bare git repo in your `$HOME` directory:

```
git clone --bare https://github.com/hermannm/dotfiles.git $HOME/dotfiles
```

Then checkout the repo contents, overwriting existing config under `$HOME`:

```
git --git-dir="$HOME/dotfiles" --work-tree="$HOME" checkout -f
```

This provides the `df-g` command for managing the bare repo, using `$HOME` as its working directory. To hide untracked files from `$HOME`, run the following:

```
df-g config --local status.showUntrackedFiles no
```

## Platforms

The `main` branch contains config files for Linux (Ubuntu). To configure other platforms, specify the platform-specific branch to clone:

```
git clone -b [BRANCH_NAME] --single-branch --bare https://github.com/hermannm/dotfiles.git $HOME/dotfiles
```

Alternate platform branches currently available are `windows`, `wsl` and `macos`.
