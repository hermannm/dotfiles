# Sets terminal title to the currently running program.
echo -ne "\033]1;$0\a"

# Sets up the prompt with git branch name.
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{white}:%F{magenta}%b'
setopt PROMPT_SUBST
PROMPT='%F{blue}${PWD/#$HOME/~}${vcs_info_msg_0_}%F{white}\$%{$reset_color%} '

# Configures shell history.
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Configures autosuggestions for zsh, if it's installed.
if [ -d "${HOME}/zsh/plugins/zsh-autosuggestions" ] ; then
    source "${HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY="completion"
    bindkey '^I' autosuggest-accept
fi

# Sets PATH to include private bin, if it exists.
if [ -d "${HOME}/bin" ] ; then
    PATH="${HOME}/bin:${PATH}"
fi
if [ -d "${HOME}/.local/bin" ] ; then
    PATH="${HOME}/.local/bin:${PATH}"
fi

# Sets Nano as default editor.
export EDITOR=nano
export VISUAL="${EDITOR}"

# Sets up GPG signing.
export GPG_TTY=$(tty)

# Adds Go to PATH.
export PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"

# Initializes Python environment.
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init --path)"

# Configures Deno.
export DENO_INSTALL="${HOME}/.deno"
export PATH="${DENO_INSTALL}/bin:${PATH}"

# Initializes Node Version Manager.
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"

# Configures kubectl to use gcloud auth.
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Configures Django for indok-web project.
export DJANGO_READ_DOT_ENV_FILE=true

# Loads utility functions and aliases.
if [ -f ~/zsh/aliases ]; then
    source ~/zsh/aliases
fi

# Loads keybindings.
if [ -f ~/zsh/keybindings ]; then
    source ~/zsh/keybindings
fi

# Loads secrets.
if [ -f ~/zsh/secrets ]; then
    source ~/zsh/secrets
fi
