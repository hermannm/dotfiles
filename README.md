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
