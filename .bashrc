# Exits if not running interactively.
case $- in
    *i*) ;;
      *) return;;
esac

# Configures history.
HISTCONTROL=ignoreboth # Ignores duplicate lines, and lines starting with space.
shopt -s histappend # Appends to the history instead of overwriting.
HISTSIZE=1000 # Sets history length.
HISTFILESIZE=2000 # Sets history file size.

# Updates lines and columns to match window size.
shopt -s checkwinsize

# Improves 'less' for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Sets directory variable for use in prompt.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Sets the prompt to show color, if the terminal supports it.
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Displays current git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Sets prompt, with colors if enabled.
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[1;32m\]\w`
    if [ $(parse_git_branch) ]; then
      echo "\[\033[0;37m\]/\[\033[1;33m\]$(parse_git_branch)"
    fi`\[\033[0;37m\]:\[\033[00m\] '
else
  PS1='${debian_chroot:+($debian_chroot)}\w`
    if [ $(parse_git_branch) ]; then
      echo /$(parse_git_branch);
    fi`: '
fi
unset color_prompt

# Enables autocomplete.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Loads aliases.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
