zmodload zsh/zprof

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

# Loads environment variables.
if [ -f ~/zsh/env ]; then
    source ~/zsh/env
fi

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

# Loads zsh-autosuggestions plugin.
if [ -d "${HOME}/zsh/plugins/zsh-autosuggestions" ] ; then
    source "${HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_STRATEGY="completion"
    bindkey '^I' autosuggest-accept
fi

# Loads zsh-shift-select plugin.
if [ -d "${HOME}/zsh/plugins/zsh-shift-select" ] ; then
    source "${HOME}/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh"
fi
