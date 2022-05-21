# dotfiles

hermannm's config files for various developer tools.

## Usage

Clone as a bare git repo in your `$HOME` directory:

```
git clone --bare https://github.com/hermannm/dotfiles.git $HOME/dotfiles
```

This provides the `dotfiles` command for managing the bare repo, using `$HOME` as its working directory. To hide untracked files from `$HOME`, run the following:

```
dotfiles config --local status.showUntrackedFiles no
```

## Platforms

The `main` branch contains config files for Ubuntu on WSL. To configure other platforms, specify the platform-specific branch to clone:

```
git clone -b [BRANCH_NAME] --single-branch --bare https://github.com/hermannm/dotfiles.git $HOME/dotfiles
```

Alternate platform branches currently available are `windows` and `macos`.
