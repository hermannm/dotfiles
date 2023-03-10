# Sets terminal title to the currently running program.
echo -ne "\033]1;${0}\a"

# Sets up the prompt with git branch name.
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{white}:%F{magenta}%b'
setopt PROMPT_SUBST
PROMPT='%F{blue}${PWD/#${HOME}/~}${vcs_info_msg_0_}%F{white}\$%{${reset_color}%} '

# Configures shell history.
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="${HOME}/.zsh_history"

# Loads environment variables.
if [ -f "${HOME}/zsh/env" ]; then
    source "${HOME}/zsh/env"
fi

# Loads utility functions and aliases.
if [ -f "${HOME}/zsh/aliases" ]; then
    source "${HOME}/zsh/aliases"
fi

# Loads keybindings.
if [ -f "${HOME}/zsh/keybindings" ]; then
    source "${HOME}/zsh/keybindings"
fi

# Loads secrets.
if [ -f "${HOME}/zsh/secrets" ]; then
    source "${HOME}/zsh/secrets"
fi

# Loads zsh-autosuggestions plugin.
if [ -d "${HOME}/zsh/plugins/zsh-autosuggestions" ] ; then
    autoload -Uz compinit && compinit
    source "${HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY="completion"
    bindkey '^I' autosuggest-accept
fi

# Loads zsh-shift-select plugin.
if [ -d "${HOME}/zsh/plugins/zsh-shift-select" ] ; then
    source "${HOME}/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh"
fi
