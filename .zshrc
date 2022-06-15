# Sets up the prompt with git branch name.
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{white}/%F{yellow}%b'
setopt PROMPT_SUBST
PROMPT='%F{green}${PWD/#$HOME/~}${vcs_info_msg_0_}%F{white}:%{$reset_color%} '

# Configures shell history.
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Configures autosuggestions for zsh.
source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY="completion"
bindkey '^I' autosuggest-accept

# Aliases ls to always color directories.
alias ls='ls --color=auto'

# Aliases for git management of dotfiles.
alias dotfiles='git --git-dir="$HOME/dotfiles" --work-tree="$HOME"'
alias dotfiles-ls='dotfiles ls-tree main -r --name-only'

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

# Sets PATH to include private bin, if it exists.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Sets Nano as default editor.
export EDITOR=nano
export VISUAL="$EDITOR"

# Sets up GPG signing.
export GPG_TTY=$(tty)

# Adds Go to PATH.
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# Initializes Python environment.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Initializes Node Version Manager.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-detects Node version on directory change.
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
