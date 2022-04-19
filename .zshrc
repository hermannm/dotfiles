# Sets up the prompt with git branch name.
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{white}/%F{yellow}%b'
setopt PROMPT_SUBST
PROMPT='%F{green}${PWD/#$HOME/~}${vcs_info_msg_0_}%F{white}:%{$reset_color%} '

# Alias ls to always color directories.
alias ls='ls -G'

# Alias for git management of dotfiles.
alias dotfiles='git --git-dir="$HOME/dotfiles" --work-tree="$HOME"'

# Alias for opening VSCode workspaces.
alias codew='code web.code-workspace'

# Short-form for Docker Compose. Overwrites built-in dc command.
alias dc='docker compose'
# Short-form for using Docker Compose with M1 mac config file.
alias dcm1='docker compose -f docker-compose-m1.yml'

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

# Sets Nano as default editor.
export EDITOR=nano
export VISUAL="$EDITOR"

# Sets up GPG signing.
export GPG_TTY=$(tty)

# Sets up Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Configures autosuggestions for zsh.
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY="completion"
bindkey '^I' autosuggest-accept

# Initializes Python environment.
eval "$(pyenv init --path)"

# Sets up pipx for running Python packages.
export PATH="$PATH:/Users/hermannm/.local/bin"

# Configures Java Home.
export JAVA_HOME=$(/usr/libexec/java_home)

# Sets up Node Version Manager to auto-detect Node version on folder change.
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
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

# Fixes Postgres for Django.
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib -L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include -I/opt/homebrew/opt/libpq/include"
