# Adds colors to specified commands.
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Adds 'alert' alias for long-running commands. Example use: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias for git management of dotfiles.
alias dotfiles='git --git-dir="$HOME/dotfiles" --work-tree="$HOME"'

# Alias for opening VSCode workspaces.
alias codew='code web.code-workspace'

# Short-form for Docker Compose. Overwrites built-in dc command.
alias dc='docker compose'

# Command to enter Python virtual environment in provided path.
venv() {
    venv_path="venv/bin/activate"
    if [ $# -eq 0 ]
    then
        source $venv_path
    else
        target_dir="$1"
        previous_dir=$(pwd)
        cd $target_dir && source $venv_path
        cd $previous_dir
    fi
}

# Auto-detects Node version on folder change.
enter_directory() {
    if [[ $PWD == $PREV_PWD ]]; then
        return
    fi

    if [[ "$PWD" =~ "$PREV_PWD" && ! -f ".nvmrc" ]]; then
        return
    fi

    PREV_PWD=$PWD
    if [[ -f ".nvmrc" ]]; then
        nvm use
        NVM_DIRTY=true
    elif [[ $NVM_DIRTY = true ]]; then
        nvm use default
        NVM_DIRTY=false
    fi
}
export PROMPT_COMMAND=enter_directory
